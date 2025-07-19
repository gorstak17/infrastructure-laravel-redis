resource "aws_ssm_parameter" "app_key" {
  name  = "/laravel-counter/app_key"
  type  = "SecureString"
  value = var.app_key
}

resource "aws_ssm_parameter" "redis_endpoint" {
  name  = "/laravel-counter/redis_endpoint"
  type  = "String"
  value = var.redis_endpoint
}
