
resource "aws_secretsmanager_secret" "secret_credentials" {
  name                    = var.name
  tags                    = var.tags
  description             = var.description
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "secret_credentials_version" {
  secret_id     = aws_secretsmanager_secret.secret_credentials.id
  secret_string = <<EOF
{
  "username"   : "${var.username}",
  "password"   : "${var.password}",
  "host"       : "${var.db_host}",
  "host_reader": "${var.db_host_reader}",
  "port"       : "${var.db_port}",
  "db_name"    : "${var.db_name}"
}
EOF
}