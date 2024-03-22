locals {
  image = var.container_image
  container_name = var.container_name
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_vpc" "application_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_tag]
  }
}

data "aws_subnets" "alb_public" {
  filter {
    name   = "tag:Name"
    values = var.alb_subnet_tags
  }
}

data "aws_subnets" "ecr_private_subnets" {
  filter {
    name   = "tag:Name"
    values = var.ecs_subnet_tags
  }
}

data "aws_ecs_cluster" "ecs_cluster" {
  cluster_name = var.cluster_name
}

data "aws_alb_listener" "alb_listener" {
  arn = var.lb_listener_arn
}

data "aws_lb_target_group" "alb_target_group" {
  arn = var.lb_tg_arn
}

data "aws_ssm_parameter" "api_key_param" {
  name = var.param_lb_apikey_setting
}

