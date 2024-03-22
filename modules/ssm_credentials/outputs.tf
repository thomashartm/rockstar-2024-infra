output "secrets_name" {
  value = aws_secretsmanager_secret.secret_credentials.name
}

output "secrets_id" {
  value = aws_secretsmanager_secret_version.secret_credentials_version.id
}

output "secrets_string" {
  value = aws_secretsmanager_secret_version.secret_credentials_version.secret_string
}

output "secrets_arn" {
  value = aws_secretsmanager_secret.secret_credentials.arn
}
