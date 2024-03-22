include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "iam_roles" {
  config_path = "../iam"
  mock_outputs = {
    poweruser_role_arn   = "arn:aws:rds-db:eu-central-1:232312322323:groups:/poweruser"
    poweruser_role_name   = "poweruser"
  }
}

include "component" {
  path   = "${dirname(find_in_parent_folders())}/_common/ecr.hcl"
  expose = true
}

inputs = {
  name  = "chataemclient"
  user_access_role = dependency.iam_roles.outputs.poweruser_role_arn
  cicd_access_role = dependency.iam_roles.outputs.poweruser_role_arn
}