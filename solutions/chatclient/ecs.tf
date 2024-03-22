##########################
# Elastic Container Service
##########################
module "alb_listener_rule" {
  source       = "../../modules/alb/alb-listener-rule"
  listener_arn = data.aws_alb_listener.alb_listener.arn
  priority     = 100
  path_pattern = ["/*"]
  target_groups = [
    {
      arn = data.aws_lb_target_group.alb_target_group.arn
    }
  ]
  http_headers = [
    {
      name  = "xcdnauth"
      values = [data.aws_ssm_parameter.api_key_param.value]
    }
  ]
}

module "ecs_security_groups" {
  source                 = "../../modules/ecs/security-groups"
  name                   = "${var.name}-${var.environment}-ecs-sg"
  environment            = var.environment
  vpc_id                 = data.aws_vpc.application_vpc.id
  tags                   = var.tags
  revoke_rules_on_delete = true
  ingress_rules = [
    {
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "Default service rule"
    }
  ]
}

module "ecs_task_definition" {
  source      = "../../modules/ecs/ecs-task"
  name        = var.name
  environment = var.environment
  tags        = var.tags

  image                  = local.image
  container_name         = local.container_name
  host_port              = var.host_port
  container_port         = var.container_port
  container_environment  = [
    {
      "name" : "ENABLE_LOGGING", "value" : "true"
    },
    { name = "LOG_LEVEL", value = var.container_log_level },
    { name = "PORT", value = var.container_port },
    { name = "DB_", value = var.container_port },
    { name = "PORT", value = var.container_port },
    { name = "DB_SECRET_NAME", value = var.db_secret_name },
    { name = "OPENAI_API_KEY", value = var.open_api_key_secret_name },
  ]
  logs_retention_in_days = var.logs_retention_in_days
  task_container_cpu     = var.container_cpu
  task_container_memory  = var.container_memory
  depends_on = [module.ecs_security_groups]
}


module "ecs_service" {
  source                     = "../../modules/ecs/ecs-service"
  name                       = var.name
  environment                = var.environment
  tags                       = var.tags
  container_port             = var.container_port
  service_security_group_ids = [module.ecs_security_groups.id]
  service_subnet_ids         = toset(data.aws_subnets.ecr_private_subnets.ids)
  alb_target_group_arn       = data.aws_lb_target_group.alb_target_group.arn
  task_definition            = module.ecs_task_definition.task_arn
  cluster_id                 = data.aws_ecs_cluster.ecs_cluster.id
  container_name             = local.container_name
  service_desired_count      = var.service_desired_count
  max_auto_scaling_capacity  = var.max_auto_scaling_capacity
  min_auto_scaling_capacity  = var.min_auto_scaling_capacity
  depends_on                 = [module.ecs_task_definition]
}