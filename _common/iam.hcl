terraform {
  source = "${local.base_source_url}?ref=${local.module_version}"
}

locals {
  base_source_url = "git::git@github.com:thomashartm/rockstar-2024-infra.git//modules/iam-roles"

  # Automatically load environment-level variables
  commons          = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract out common variables for reuse
  default_region = local.account_vars.locals.default_region
  module_version = local.environment_vars.locals.gh_version
  env            = local.environment_vars.locals.stage
  common_tags    = {
    Maintainer  = local.commons.inputs.global_vars.maintainer
    Owner       = local.commons.inputs.global_vars.owner
    Project     = local.commons.inputs.global_vars.project
    Application = "chataem-ecr-${local.env}"
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
  tags             = local.common_tags
}