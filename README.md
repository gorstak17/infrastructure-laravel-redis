# Deploying Laravel Counter on AWS ECS (Fargate)

A containerized **Laravel counter**, deployed on **AWS ECS Fargate** via **Terraform-based Infrastructure as Code (IaC)**.  
The architecture includes:

- **ECR** for Docker image storage
- **ECS Fargate** for serverless container orchestration
- **ElastiCache Redis** for caching
- **AWS SSM Parameter Store** for secret and config management
- **Application Load Balancer (ALB)** for scalable HTTP ingress
- **VPC with public/private subnets**, NAT Gateway, and secured **Security Groups**

End-to-end **CI/CD automation** is implemented with **GitHub Actions**, covering:

- Code checkout via actions/checkout@v3
- AWS credentials setup using aws-actions/configure-aws-credentials@v2
- Docker build, push to ECR, and ECS service update via the build_and_push.sh script
- Deployment executed on ubuntu-latest runner, triggered by pushes to the master branch

This setup simulates a production-ready, scalable microservice deployment on AWS, running a Laravel-based counter app.

---

## 📁 Repo Layout

```
.
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions pipeline
├── infrastructure/
│   ├── main.tf                 # Root Terraform config
│   ├── variables.tf            # Root variables
│   ├── outputs.tf              # Root outputs
│   ├── ssm_parameters.tf       # Creates SSM parameters for app_key & redis_endpoint
│   ├── terraform.tfvars.example
│   └── modules/
│       ├── vpc/                # VPC + subnets + NAT + route tables
│       ├── redis/              # ElastiCache Redis
│       ├── ecr/                # ECR repo
│       ├── iam/                # IAM roles including ecs_ssm_access
│       └── ecs/                # ECS cluster, ALB, task definition & service
├── laravel-counter/            # Laravel app
│   ├── Dockerfile
│   ├── docker-entrypoint.sh    # Fetches secrets
│   └── …                       # Typical Laravel structure
├── scripts/
│   ├── infra_deploy.sh         # terraform init/plan/apply
│   └── build_and_push.sh       # docker build/push & ECS rollout
└── README.md                   # ← You are here
```

---

## 🔧 1. Prerequisites

### 1.1 AWS CLI & Terraform

- ✅ **Install AWS CLI v2:**  
  [Official AWS CLI v2 installation guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

- ✅ **Configure AWS CLI:**

  ```bash
  aws configure
  ```

  You will be prompted to enter:

  - AWS Access Key ID
  - AWS Secret Access Key
  - Default region name (e.g. `us-east-1`)
  - Default output format (e.g. `json`)

- ✅ **Install Terraform ≥ 1.0:**  
  [Official Terraform installation guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

- ✅ **Verify installation:**
  ```bash
  aws --version
  terraform version
  ```

### 1.2 AWS IAM User

- Create an IAM user (e.g. `terraform-user`) with **programmatic access**.
- Attach this managed policy:
  - `AdministratorAccess`

> ⚠️ **Note:**  
> For simplicity in this demo, we assign the **`AdministratorAccess`** policy to the IAM user.  
> In production, you should scope permissions more tightly, granting only what is necessary:
>
> - ECR access
> - ECS provisioning
> - CloudWatch Logs
> - SSM Parameter Store (read/write) for secrets

> ✅ Additionally, the ECS Task IAM Role already has the `ecs_ssm_access` inline policy via Terraform (`infrastructure/modules/iam/main.tf`). No need to manually add it.

### 1.3 GitHub Secrets

In your repository → **Settings → Secrets and variables → Actions → Repository secrets**, add:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

---

## 📝 2. Laravel APP_KEY Generation

From your **Laravel app directory**:

```bash
cd laravel-counter
php artisan key:generate --show
```

Copy the generated key value.

Paste the value into **`infrastructure/terraform.tfvars`** under `app_key`:

```hcl
app_name       = "laravel-counter"
app_env        = "production"
app_debug      = false
app_url        = "http://<your-alb-dns>/"
app_key        = "base64:xxxxx"   # <-- Paste here
```

> ⚠️ **Do not commit** `terraform.tfvars`.
> 📌 **TODO:** In the future, implement an automated process for `APP_KEY` rotation or secure re-initialization to enhance long-term security.

---

## ⚙️ 3. Provision AWS Infrastructure

Make the script executable:

```bash
chmod +x scripts/infra_deploy.sh
```

Run the infrastructure deploy script:

```bash
./scripts/infra_deploy.sh
```

### ✅ What happens:

- Runs `terraform init`, `validate`, `fmt`, `plan`, `apply`
- Provisions:
  - VPC, Subnets (public/private)
  - NAT Gateway
  - Security Groups
  - ECR Repository
  - ElastiCache Redis
  - ECS Cluster
  - Application Load Balancer (ALB)
  - ECS Task Definition & Service
- Writes the provided `app_key` to SSM Parameter Store `/laravel-counter/app_key`
- Stores Redis endpoint to `/laravel-counter/redis_endpoint` in SSM

---

## 🚀 4. Build & Deploy Application - Manual Deployment (Optional)

Make the build script executable:

```bash
chmod +x scripts/build_and_push.sh
```

Run it:

```bash
./scripts/build_and_push.sh
```

### ✅ What it does:

- Builds the Docker image `laravel-counter:latest`
- Tags & pushes the image to ECR
- Triggers ECS to deploy the new image:

```bash
aws ecs update-service   --cluster ${CLUSTER_NAME}   --service ${SERVICE_NAME}   --force-new-deployment   --region ${AWS_REGION}
```

---

## 🌐 5. Networking Overview

```text
                +-------------------+
                |    Internet        |
                +-------------------+
                          │
                       HTTP 80/443
                          │
                +-------------------+
                |  Application Load  |
                |    Balancer (ALB)  |
                |  [Public Subnet]   |
                +-------------------+
                          │
                       Target Group
                          │
            +---------------------------+
            | ECS Tasks (Laravel App)    |
            |     [Private Subnets]      |
            +---------------------------+
                   │                │
            Redis Queries       Outbound HTTPS
                   │                │
     +-----------------+    +---------------------+
     | ElastiCache Redis|    |  NAT Gateway        |
     | [Private Subnet] |    |  [Public Subnet]    |
     +-----------------+    +---------------------+
                                  │
                             +----------+
                             | Internet |
                             +----------+
```

- **Public Subnets:**  
  Host the **Application Load Balancer (ALB)** and **NAT Gateway**.

  - The ALB is exposed to the internet, listening on ports **80 (HTTP)** and optionally **443 (HTTPS)**.
  - The NAT Gateway enables resources in private subnets to access the internet securely without being exposed.

- **Private Subnets:**  
  Host compute and data resources that should not be publicly accessible:

  - **ECS Tasks (Laravel app containers):** Handle application logic and business operations.
  - **ElastiCache Redis:** Provides fast, in-memory data caching for the Laravel app.

- **Security Groups (Firewall rules at instance/network interface level):**

  - **ALB → ECS:**

    - ALB forwards incoming traffic from the internet to ECS tasks on **port 8000**, where the Laravel app listens.

  - **ECS → Redis:**

    - ECS tasks can communicate with Redis only on **port 6379**, ensuring cache communication is isolated within the private network.

  - **ECS → Internet:**
    - ECS tasks connect to the internet via the **NAT Gateway** for:
      - **AWS SSM Parameter Store:** Retrieve secrets like `app_key` and Redis endpoint at runtime.
      - **Amazon ECR:** Pull the latest Docker image versions during task startup.
      - **CloudWatch Logs:** Push application logs for monitoring and observability.

> 🔐 All traffic between services is tightly controlled by security group rules to ensure **least-privilege access** and protect the network from unnecessary exposure.

---

## 📖 6. Design Decisions

- **ElastiCache Redis** for low-latency caching
- **SSM Parameter Store** for secure secret storage (`app_key`, `redis_endpoint`)
- **Fargate** for serverless container hosting
- **Terraform modules** for reusable infrastructure
- **GitHub Actions** for automated CI/CD pipelines

---

## 🔁 7. CI/CD with GitHub Actions

- **Workflow File:** `.github/workflows/deploy.yml`
- **Trigger:** On push to **master** branch.

### ✅ Steps:

1. Code is checked out automatically by the pipeline
2. AWS credentials are configured via aws-actions/configure-aws-credentials@v2 using stored GitHub Secrets
3. The pipeline executes the deployment script (build_and_push.sh), which builds the Docker image, pushes to ECR, and updates ECS service

   ```bash
   ./scripts/build_and_push.sh
   ```
