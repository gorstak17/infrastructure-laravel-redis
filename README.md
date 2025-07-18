# DevOps Take-Home Test

## Introduction

Welcome to the DevOps take-home test. The goal of this test is to assess your skills in deploying a Laravel application on AWS using Infrastructure as Code (IaC). The application is a simple web counter that stores its count in a Redis backend.

You are required to fork this repository, complete the task as described below, and commit your code back to your forked repository.

---

## 🎯 Objective

Deploy a **Dockerized Laravel-based web counter** application on **AWS ECS using Fargate**, using Terraform as your Infrastructure-as-Code tool.

---

## ✅ Requirements

### 1. Infrastructure as Code (Terraform)
Use **Terraform** to provision the following resources:

- VPC (with public/private subnets, route tables, internet gateway, NAT gateway)
- ECS Cluster (Fargate)
- ECR repository for Laravel app container
- Application Load Balancer (ALB)
- Redis (Amazon ElastiCache)
- IAM Roles for ECS tasks and services
- Security Groups and necessary networking components

### 2. Laravel App Setup (Dockerized)

- Dockerize the Laravel counter app
- Ensure it connects to Redis
- Store environment variables (e.g., Redis endpoint, app key) securely

### 3. Deployment Flow

- Build Docker image for the Laravel app
- Push image to Amazon ECR
- Configure ECS Task Definition and Service using Fargate
- Ensure the app is reachable via a public Load Balancer DNS

### 4. Configuration Management

Use **Terraform scripts and optional shell scripts** to automate provisioning. If additional tools like Ansible or Bash are used, document their usage clearly.

### 5. Environment Variables

Manage sensitive values using environment variables (no hardcoding credentials). Use Terraform to inject values securely into ECS.

### 6. Documentation

Provide a complete `README.md` with:
- Setup instructions
- Explanation of design decisions
- Deployment steps from start to finish
- Environment structure and networking

---

## 📦 Deliverables

1. **Infrastructure Code**
   - All relevant Terraform files (`main.tf`, `variables.tf`, `outputs.tf`, etc.) under `/infrastructure` directory

2. **Dockerized Laravel App**
   - Include a Dockerfile and (optionally) a `docker-compose.yml` for local testing

3. **Deployment Pipeline (Bonus)**
   - Extra credit for deploying via GitHub Actions, CodePipeline, or similar

4. **Screenshare Capture Video**
   - Record a walkthrough where you:
     - Explain your approach
     - Walk through the code and infrastructure
     - Talk about challenges and solutions
   - **Camera use is optional**, but you should share your screen and speak clearly.

5. **README.md**
   - Should contain everything needed for another engineer to replicate your deployment

---

## 🚀 Submission Instructions

1. Export your repository as a `.zip` or `.tar` archive
2. Submit the archive to your contact at Gambling.com Group

---

## 💡 Notes

- You **must use ECS with Fargate** for deployment
- Use of Terraform is **mandatory**
- You might need to refactor the instructional files. 
- Keep code clean, modular, and well-documented
- Tag resources for traceability where applicable

Good luck! We look forward to reviewing your work 🚀å 