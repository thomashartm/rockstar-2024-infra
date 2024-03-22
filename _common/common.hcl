terraform {
  source = "${local.base_source_url}?ref=${local.module_version}"
}

locals {
  base_source_url = "git::git@github.com:thomashartm/rockstar-2024-infra.git//solutions/common"

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
  environment                = local.env
  region                     = local.default_region
  tags                       = local.common_tags
  # Certificate settings
  domain                     = local.domain
  cloudfront_domain          = local.cloudfront_domain
  hosted_zone                = local.hosted_zone
  alternatives_subdomains    = ["*.${local.domain}"]
  alternatives_subdomains_cf = ["*.${local.cloudfront_domain}"]
  acm_region                 = local.default_region
  api_credential_secret      = local.account_vars.locals.api_credential_secret
}