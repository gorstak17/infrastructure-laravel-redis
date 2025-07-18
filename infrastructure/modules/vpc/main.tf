# Define your custom VPC, subnets, IGW, route tables, NAT here
# Or call a module if allowed

module "this" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name              = "${var.app_name}-vpc"
  cidr              = var.vpc_cidr
  azs               = var.availability_zones
  public_subnets    = var.public_subnets
  private_subnets   = var.private_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Environment = var.env
    Application = var.app_name
  }
}
