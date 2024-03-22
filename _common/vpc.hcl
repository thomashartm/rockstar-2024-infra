terraform {
  source = "${local.base_source_url}?ref=${local.module_version}"
}

locals {
  base_source_url = "git::git@github.com:thomashartm/rockstar-2024-infra.git//solutions/vpc"

  # Automatically load environment-level variables
  commons          = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract out common variables for reuse
  default_region = local.account_vars.locals.default_region
  module_version = local.environment_vars.locals.gh_version
  env            = local.environment_vars.locals.stage
  service_name   = "chataem-vpc-network"

  domain            = local.account_vars.locals.domain_name
  cloudfront_domain = local.account_vars.locals.cloudfront_domain_name
  hosted_zone       = local.account_vars.locals.hosted_zone
  common_tags       = {
    Maintainer  = local.commons.inputs.global_vars.maintainer
    Owner       = local.commons.inputs.global_vars.owner
    Project     = local.commons.inputs.global_vars.project
    Application = "chataem-${local.service_name}-${local.env}"
    DeployedBy  = ""
    Repository  = local.base_source_url
    STAGE       = local.env
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  environment               = local.env
  region                    = local.default_region
  tags                      = local.common_tags
  vpc_tag                   = local.environment_vars.locals.vpc_tag
  name                      = local.environment_vars.locals.vpc_name
  azs                       = local.environment_vars.locals.vpc_azs
  cidr                      = local.environment_vars.locals.vpc_cidr
  #private_subnets           = local.environment_vars.locals.vpc_private_subnets
  #public_subnets            = local.environment_vars.locals.vpc_public_subnets
  #database_subnet_tag       = local.environment_vars.locals.vpc_database_subnet_tag
  enable_nat_gateway        = local.environment_vars.locals.vpc_enable_nat_gateway
  enable_vpn_gateway        = local.environment_vars.locals.vpc_enable_vpn_gateway
  # Internal security group settings
  internal_sg_group_name    = local.environment_vars.locals.internal_sg_name
  internal_sg_ingress_rules = [
    {
      from_port        = 0
      to_port          = 65535
      protocol         = "tcp"
      cidr_blocks      = ["172.22.0.0/16"]
      description      = "INT"
      ipv6_cidr_blocks = []
    },
    {
      from_port        = 0
      to_port          = 65535
      protocol         = "tcp"
      description      = "VPN"
      cidr_blocks      = ["10.88.0.0/16"]
      ipv6_cidr_blocks = []
    }
  ]
  internal_sg_egress_rules = [
    {
      from_port        = 0
      to_port          = 65535
      protocol         = "tcp"
      description      = "Outbound"
      ipv6_cidr_blocks = []
      cidr_blocks      = ["0.0.0.0/0"]
    }
  ]
}