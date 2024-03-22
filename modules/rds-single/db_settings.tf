locals {
  region                = data.aws_region.current.id
  account_id            = data.aws_caller_identity.current.account_id
  db_resource_arn       = "arn:aws:rds-db:${local.region}:${local.account_id}:dbuser:${aws_db_instance.postgresql.resource_id}/${random_string.master_user.result}"
  db_proxy_resource_arn = "arn:aws:rds-db:${local.region}:${local.account_id}:dbuser:${element(split(":", aws_db_proxy.rds_db_proxy.arn), 6)}/*"
}
resource "aws_ssm_parameter" "db_settings_param" {
  name        = var.db_settings_param_name
  tags        = var.tags
  description = "DB Settings parameter."
  type        = "SecureString"
  value       = <<EOF
    {
        "db_resource_arn": "${local.db_resource_arn}",
        "db_proxy_resource_arn": "${local.db_proxy_resource_arn}",
        "proxy_endpoint": "${aws_db_proxy.rds_db_proxy.endpoint}",
        "proxy_arn": "${aws_db_proxy.rds_db_proxy.arn}",
        "db_name": "${local.db_name}",
        "db_identifier": "${local.db_name}",
        "port": "${var.database_port}"
    }
EOF
}

# db_resource_arn       = "arn:aws:rds-db:${local.account_vars.locals.default_region}:${local.account_vars.locals.aws_account_id}:dbuser:${dependency.database.outputs.dbi_resource_id}/${dependency.database.outputs.db_username}"
# db_proxy_resource_arn = "arn:aws:rds-db:${local.account_vars.locals.default_region}:${local.account_vars.locals.aws_account_id}:dbuser:${element(split(":", dependency.database.outputs.db_proxy_arn),6)}/*"