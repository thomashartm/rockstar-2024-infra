resource "aws_ecs_cluster" "cluster" {
  name = "${var.name}-${var.environment}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge({
    "Name" : "ECS-cluster-${var.name}"
  }, var.tags)
}