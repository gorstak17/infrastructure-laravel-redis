# Define:
# - aws_ecs_cluster
# - aws_ecs_task_definition
# - aws_ecs_service
# - application load balancer

resource "aws_ecs_cluster" "this" {
  name = "${var.app_name}-cluster"
}

resource "aws_cloudwatch_log_group" "laravel_counter" {
  name              = "/ecs/${var.app_name}"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.app_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn


  container_definitions = jsonencode([
    {
      name  = var.app_name
      image = var.ecr_image
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "APP_KEY"
          value = ""
        },
        {
          name  = "APP_ENV"
          value = var.app_env
        },
        {
          name  = "APP_DEBUG"
          value = tostring(var.app_debug)
        },
        {
          name  = "APP_URL"
          value = var.app_url
        },
        {
          name  = "CACHE_DRIVER"
          value = var.cache_driver
        },
        {
          name  = "SESSION_DRIVER"
          value = var.session_driver
        },
        {
          name  = "QUEUE_CONNECTION"
          value = var.queue_connection
        },

        {
          name  = "REDIS_CLIENT"
          value = var.redis_client
        },
        {
          name  = "REDIS_HOST"
          value = ""
        },
        {
          name  = "REDIS_PASSWORD"
          value = var.redis_password
        },
        {
          name  = "REDIS_PORT"
          value = tostring(var.redis_port) # 6379
        },

        {
          name  = "MAIL_MAILER"
          value = var.mail_mailer
        }
      ]


      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.app_name}"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}


resource "aws_lb" "main" {
  name               = "${var.app_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_target_group" "app" {
  name        = "${var.app_name}-tg"
  port        = 8000
  protocol    = "HTTP"
  target_type = "ip"

  vpc_id = var.vpc_id

  health_check {
    path                = "/"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_ecs_service" "app" {
  name            = "${var.app_name}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = var.app_name
    container_port   = 8000
  }

  depends_on = [aws_lb_listener.http]
}

