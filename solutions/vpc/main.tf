locals {
  region = data.aws_region.current.name
}

data "aws_region" "current" {}

module "vpc" {
  source           = "terraform-aws-modules/vpc/aws"
  version          = "5.5.2"
  name             = var.vpc_name
  azs              = var.azs
  cidr             = "10.0.0.0/16"
  database_subnets = ["10.0.23.0/24", "10.0.24.0/24"]
  private_subnets  = ["10.0.20.0/24", "10.0.19.0/24"]
  public_subnets   = ["10.0.22.0/24", "10.0.21.0/24"]

  enable_nat_gateway                     = true
  enable_vpn_gateway                     = true
  enable_dns_support                     = true
  enable_dns_hostnames                   = true
  create_database_subnet_group           = true
  create_database_subnet_route_table     = true

  create_database_internet_gateway_route = true

  public_subnet_tags_per_az = {
    "${local.region}a" = {
      Name : "${var.public_subnet_tag}_subnet_a",
      Group : var.public_subnet_tag
    },
    "${local.region}b" = {
      Name : "${var.public_subnet_tag}_subnet_b",
      Group : var.public_subnet_tag
    }
  }

  private_subnet_tags_per_az = {
    "${local.region}a" = {
      Name : "${var.private_subnet_tag}_subnet_a",
      Group : var.private_subnet_tag
    },
    "${local.region}b" = {
      Name : "${var.private_subnet_tag}_subnet_b",
      Group : var.private_subnet_tag
    }
  }

  database_subnet_tags = {
    Name : var.database_subnet_tag,
    Group : var.database_subnet_tag
  }

  database_subnet_group_tags = {
    Name : var.database_subnet_tag,
    Group : var.database_subnet_tag
  }

  vpc_tags = {
    Name = var.vpc_tag
  }
  tags = var.tags
}
