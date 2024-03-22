terraform {
  source = "${local.base_source_url}?ref=${local.module_version}"
}

locals {
  base_source_url = "git::git@github.com:thomashartm/rockstar-2024-infra.git//modules/rds-single"

  # Automatically load environment-level variables
  commons          = read_terragrunt_config(find_in_parent_folders("common.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  account_vars     = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Extract out common variables for reuse
  module_version   = local.environment_vars.locals.gh_version
  stage            = local.environment_vars.locals.stage
  default_region   = local.account_vars.locals.default_region
  db_instance_name = local.environment_vars.locals.db_name
  sn_tag = local.environment_vars.locals.database_subnet_tag
  common_tags = {
    Maintainer  = local.commons.inputs.global_vars.maintainer
    Project     = local.commons.inputs.global_vars.project
    Application = "chataem-rds-vectorstore-db"
    DeployedBy  = ""
    Repository  = local.base_source_url
    Branch      = local.module_version
    STAGE       = local.stage
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  stage                     = local.stage
  db_instance_name          = "${local.stage}${local.db_instance_name}"
  db_settings_param_name    = "${local.stage}${local.db_instance_name}-settings"
  tags                      = local.common_tags
  vpc_tag                   = local.environment_vars.locals.vpc_tag # e.g. "vpc"
  subnet_tags               = [local.sn_tag]
  security_group_names      = local.environment_vars.locals.security_group_names # e.g. ["internal_ranges"]
  alarm_actions             = []
  ok_actions                = []
  insufficient_data_actions = []
}