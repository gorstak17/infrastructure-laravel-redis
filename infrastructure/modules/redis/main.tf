# Define your Redis cluster using aws_elasticache_replication_group
# Make sure to place it in the same VPC

resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.env}-redis-subnet-group"
  subnet_ids = var.private_subnet_ids
}

# resource "aws_elasticache_cluster" "redis" {
#   cluster_id           = "${var.env}-redis"
#   engine               = "redis"
#   node_type            = "cache.t3.micro"
#   num_cache_nodes      = 1
#   subnet_group_name    = aws_elasticache_subnet_group.this.name
#   security_group_ids   = [var.redis_sg_id]
#   parameter_group_name = "default.redis7"
# }

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id = "${var.env}-redis"
  description          = "Redis replication group for ${var.env} environment"

  engine         = "redis"
  engine_version = "7.0"
  node_type      = "cache.t3.micro"

  num_node_groups         = 1
  replicas_per_node_group = 1

  multi_az_enabled           = true
  automatic_failover_enabled = true

  subnet_group_name    = aws_elasticache_subnet_group.this.name
  security_group_ids   = [var.redis_sg_id]
  parameter_group_name = "default.redis7"
  port                 = 6379

  tags = {
    Environment = var.env
  }
}



