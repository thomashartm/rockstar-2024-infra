terraform {
  source = "${local.base_source_url}?ref=${local.module_version}"
}

locals {
  base_source_url = "git::git@github.com:thomashartm/rockstar-2024-infra.git//solutions/sharedecs-deps"

  # Automatically load environment-level variables
  commons          = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract out common variables for reuse
  default_region = local.account_vars.locals.default_region
  module_version = local.environment_vars.locals.gh_version
  env            = local.environment_vars.locals.stage
  service_name   = "chataem-ecs-shared"
  pub_sn         = local.environment_vars.locals.public_subnet_tag
  pri_sn         = local.environment_vars.locals.private_subnet_tag
  common_tags    = {
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
  environment         = local.env
  region              = local.default_region
  tags                = local.common_tags
  hosted_zone         = local.account_vars.locals.hosted_zone
  alb_domain          = "${local.account_vars.locals.domain_name}"
  cloudfront_domain   = local.account_vars.locals.cloudfront_domain_name
  vpc_tag             = local.environment_vars.locals.vpc_tag
  name                = "summitchataem-app"
  health_check_port   = 8080
  health_check_path   = "/api/status"
  container_log_level = "DEBUG"
  ecs_subnet_tags     = [
    "${local.pri_sn}_subnet_a", "${local.pri_sn}_subnet_b", "${local.pri_sn}_subnet_c"
  ]
  alb_subnet_tags = [
    "${local.pub_sn}_subnet_a", "${local.pub_sn}_subnet_b", "${local.pub_sn}_subnet_c"
  ]
  deployment_minimum_healthy_percent = 0
}