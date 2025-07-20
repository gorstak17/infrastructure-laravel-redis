variable "aws_region" {
  description = "AWS region to deploy to"
  default     = "us-east-1"
}

variable "app_name" {
  description = "Name of the application"
  default     = "laravel-counter"
}

variable "app_key" {
  description = "Laravel APP_KEY (run `php artisan key:generate --show`)"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability Zones to provision subnets in"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "env" {
  description = "Environment tag (dev, staging, prod)"
  default     = "dev"
}

variable "app_env" {
  description = "Laravel environment (local, production)"
  type        = string
  default     = "production"
}

variable "app_debug" {
  description = "Laravel debug mode (true/false)"
  type        = bool
  default     = false
}

variable "app_url" {
  description = "Laravel APP_URL - base URL of application"
  type        = string
}

variable "redis_client" {
  description = "Redis client for Laravel"
  type        = string
  default     = "phpredis"
}

variable "redis_password" {
  description = "Redis password if AUTH is enabled"
  type        = string
  default     = ""
}

variable "redis_port" {
  description = "Redis port"
  type        = number
  default     = 6379
}

variable "cache_driver" {
  description = "Laravel cache driver"
  type        = string
  default     = "redis"
}

variable "session_driver" {
  description = "Laravel session driver"
  type        = string
  default     = "redis"
}

variable "queue_connection" {
  description = "Laravel queue connection"
  type        = string
  default     = "redis"
}
variable "mail_mailer" {
  description = "Mail driver (smtp, log, etc.)"
  type        = string
  default     = "log"
}
