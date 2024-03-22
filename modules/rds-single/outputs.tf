output "db_username" {
  value = random_string.master_user.result
}

output "db_password" {
  value     = random_password.master_password.result
  sensitive = true
}

output "host" {
  value = aws_db_instance.postgresql.address
}

output "name" {
  value = aws_db_instance.postgresql.db_name
}

output "port" {
  value = aws_db_instance.postgresql.port
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.db_subnet.name
}

output "db_subnet_group_arn" {
  value = aws_db_subnet_group.db_subnet.arn
}

output "dbi_resource_id" {
  value = aws_db_instance.postgresql.resource_id
}

output "db_proxy_endpoint" {
  value = aws_db_proxy.rds_db_proxy.endpoint
}

output "db_proxy_arn" {
  value = aws_db_proxy.rds_db_proxy.arn
}

output "settings_param_name" {
  value = aws_ssm_parameter.db_settings_param.name
}

output "settings_param_arn" {
  value = aws_ssm_parameter.db_settings_param.arn
}