output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.this.vpc_id
}

output "public_subnets" {
  description = "IDs of public subnets"
  value       = module.this.public_subnets
}

output "private_subnets" {
  description = "IDs of private subnets"
  value       = module.this.private_subnets
}

output "nat_gateway_id" {
  description = "Single NAT Gateway ID"
  value       = module.this.natgw_ids[0]
}






