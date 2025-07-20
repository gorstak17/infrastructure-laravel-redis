
module "ecr" {
  source   = "./modules/ecr"
  app_name = var.app_name
}

module "iam" {
  source     = "./modules/iam"
  app_name   = var.app_name
  aws_region = var.aws_region
}

module "vpc" {
  source             = "./modules/vpc"
  app_name           = var.app_name
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  env                = var.env
}


module "redis" {
  source             = "./modules/redis"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets
  env                = var.env
  redis_sg_id        = aws_security_group.redis_sg.id

}

module "ecs" {
  source             = "./modules/ecs"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnets
  private_subnet_ids = module.vpc.private_subnets
  ecr_image          = module.ecr.ecr_repository_url
  execution_role_arn = module.iam.task_execution_role_arn
  task_role_arn      = module.iam.task_execution_role_arn
  alb_sg_id          = aws_security_group.alb_sg.id
  ecs_sg_id          = aws_security_group.ecs_sg.id
  app_key            = var.app_key
  app_name           = var.app_name
  redis_sg_id        = aws_security_group.redis_sg.id
  app_env            = var.app_env
  app_debug          = var.app_debug
  app_url            = var.app_url
  cache_driver       = var.cache_driver
  session_driver     = var.session_driver
  queue_connection   = var.queue_connection
  redis_client       = var.redis_client
  redis_password     = var.redis_password
  redis_port         = var.redis_port
  mail_mailer        = var.mail_mailer
}

