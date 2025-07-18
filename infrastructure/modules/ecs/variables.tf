variable "vpc_id" {
  description = "VPC ID"
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "ecr_image" {
  description = "ECR image URL for Laravel app"
}

variable "execution_role_arn" {
  description = "IAM role ARN for ECS task execution"
}

variable "alb_sg_id" {
  description = "Security Group ID for ALB"
}

variable "ecs_sg_id" {
  description = "Security Group ID for ECS tasks"
}

variable "app_key" {
  description = "Laravel APP_KEY"
}

variable "app_name" {
  description = "Application name"
}

variable "redis_sg_id" {
  description = "Security Group ID for Redis (if needed by ECS)"
  type        = string
}

variable "app_env" {
  description = "Laravel environment (local, production)"
  type        = string
}

variable "app_debug" {
  description = "Laravel debug mode"
  type        = bool
}

variable "app_url" {
  description = "Laravel APP_URL"
  type        = string
}

variable "cache_driver" {
  description = "Laravel cache driver"
  type        = string
}

variable "session_driver" {
  description = "Laravel session driver"
  type        = string
}

variable "queue_connection" {
  description = "Laravel queue connection"
  type        = string
}

variable "redis_client" {
  description = "Redis client for Laravel"
  type        = string
}

variable "redis_endpoint" {
  description = "Redis host endpoint"
  type        = string
}

variable "redis_password" {
  description = "Redis password if enabled"
  type        = string
}

variable "redis_port" {
  description = "Redis port"
  type        = number
}

variable "mail_mailer" {
  description = "Mail driver"
  type        = string
}
