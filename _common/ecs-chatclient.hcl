terraform {
  source = "${local.base_source_url}?ref=${local.module_version}"
}

locals {
  base_source_url = "git::git@github.com:thomashartm/rockstar-2024-infra.git//solutions/chatclient"

  # Automatically load environment-level variables
  commons          = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract out common variables for reuse
  default_region  = local.account_vars.locals.default_region
  module_version  = local.environment_vars.locals.gh_version
  env             = local.environment_vars.locals.stage
  account_id      = local.account_vars.locals.aws_account_id
  common_name     = "summitchataem-app"
  container_name  = "chataemclient"
  container_image = "${local.account_id}.dkr.ecr.eu-central-1.amazonaws.com/${local.container_name}"
  pub_sn          = local.environment_vars.locals.public_subnet_tag
  pri_sn          = local.environment_vars.locals.private_subnet_tag
  db_instance_name = local.environment_vars.locals.db_name
  db_secret_name  = "${local.env}${local.db_instance_name}-settings"
  common_tags     = {
    Maintainer  = local.commons.inputs.global_vars.maintainer
    Owner       = local.commons.inputs.global_vars.owner
    Project     = local.commons.inputs.global_vars.project
    Application = "${local.common_name}-${local.env}"
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
  environment             = local.env
  region                  = local.default_region
  tags                    = local.common_tags
  name                    = local.common_name
  cluster_name            = "${local.common_name}-${local.env}-cluster"
  container_name          = local.container_name
  container_image         = local.container_image
  container_image_version = "latest"
  container_log_level     = "DEBUG"
  container_port          = 8080
  host_port               = 8080
  health_check_port       = 8080
  domain_name             = local.account_vars.locals.domain_name
  ecs_subnet_tags         = [
    "${local.pri_sn}_subnet_a", "${local.pri_sn}_subnet_b", "${local.pri_sn}_subnet_c"
  ]
  alb_subnet_tags = [
    "${local.pub_sn}_subnet_a", "${local.pub_sn}_subnet_b", "${local.pub_sn}_subnet_c"
  ]
  deployment_minimum_healthy_percent = 0
  allowed_secrets                    = [local.account_vars.locals.api_credential_secret.name, local.db_secret_name]
  db_secret_name                     = "testchataemdocs-credentials"
  open_api_key_secret_name           = "summitchataem-api-credentials"

}