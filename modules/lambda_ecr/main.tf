locals {
  ecr_image_location = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.id}.amazonaws.com/${var.ecr_image_name}:${var.image_version}"
  env_vars           = {}
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

###################
# VPC Networking
###################

data "aws_vpc" "application_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_tag]
  }
}

data "aws_subnets" "application_subnets" {
  filter {
    name   = "tag:Name"
    values = var.subnet_tags
  }
}

data "aws_security_groups" "social_services_groups" {
  filter {
    name   = "group-name"
    values = var.security_group_names
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.application_vpc.id]
  }
}

# Documentation https://registry.terraform.io/modules/terraform-aws-modules/lambda/aws
module "python_lambda" {
  source                            = "terraform-aws-modules/lambda/aws"
  version                           = "5.0.0"
  function_name                     = var.function_name
  description                       = var.function_description
  tags                              = var.tags
  # code
  handler                           = var.handler
  runtime                           = var.runtime
  create_package                    = false
  image_uri                         = local.ecr_image_location
  package_type                      = "Image"
  environment_variables             = merge(local.env_vars, var.env_vars)
  layers                            = var.lambda_layer_arns
  # performance
  timeout                           = var.timeout
  memory_size                       = var.memory_size
  publish                           = true
  # networking
  vpc_subnet_ids                    = data.aws_subnets.application_subnets.ids
  vpc_security_group_ids            = data.aws_security_groups.social_services_groups.ids
  attach_network_policy             = true
  tracing_mode                      = "Active"
  # logging
  attach_tracing_policy             = true
  cloudwatch_logs_retention_in_days = 7
}