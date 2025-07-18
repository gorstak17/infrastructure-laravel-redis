variable "vpc_id" {
  description = "VPC ID for Redis subnet group"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private Subnet IDs for Redis"
  type        = list(string)
}

variable "env" {
  description = "Environment tag (dev, staging, prod)"
  type        = string
}

variable "redis_sg_id" {
  description = "Security Group ID to attach to Redis cluster"
  type        = string
}
