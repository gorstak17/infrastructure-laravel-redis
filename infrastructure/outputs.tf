output "ecr_repository_url" {
  value = module.ecr.ecr_repository_url
}

output "alb_dns_name" {
  value = module.ecs.alb_dns_name
}

output "redis_endpoint" {
  value = module.redis.redis_endpoint
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "ecs_sg_id" {
  value = aws_security_group.ecs_sg.id
}

output "vpc_nat_gateway_id" {
  description = "The single NAT Gateway ID"
  value       = module.vpc.nat_gateway_id
}

output "task_execution_role_arn" {
  value = module.iam.task_execution_role_arn
}
