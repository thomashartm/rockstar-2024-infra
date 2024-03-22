locals {

}

###################
# VPC Networking and Security
###################
data "aws_acm_certificate" "certificate" {
  domain      = var.alb_domain
  most_recent = true
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

data "aws_vpc" "application_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_tag]
  }
}
