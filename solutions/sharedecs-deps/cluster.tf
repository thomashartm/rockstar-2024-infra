##########################
# Elastic Container Service
##########################
module "ecs_cluster" {
  source      = "../../modules/ecs/ecs-cluster"
  name        = var.name
  environment = var.environment
  tags        = var.tags

  depends_on = [module.alb]
}