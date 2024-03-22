###################
# IAM resources
###################
data "aws_iam_policy_document" "rds_db_proxy_policy_doc" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "rds_db_proxy_policy_secretsmanager_doc" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
    ]
    resources = [
      "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:*"
    ]
  }
}

data "aws_iam_policy_document" "rds_db_proxy_policy_kms_doc" {
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
    ]
    resources = [
      "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/*"
    ]
  }
}

resource "aws_iam_role" "rds_db_proxy_role" {
  name               = "${local.db_name}-rds-db-proxy-role"
  assume_role_policy = data.aws_iam_policy_document.rds_db_proxy_policy_doc.json

  inline_policy {
    name   = "${local.db_name}-rds_db_proxy_policy_secretsmanager_doc"
    policy = data.aws_iam_policy_document.rds_db_proxy_policy_secretsmanager_doc.json
  }

  inline_policy {
    name   = "${local.db_name}-rds_db_proxy_policy_kms_doc"
    policy = data.aws_iam_policy_document.rds_db_proxy_policy_kms_doc.json
  }
}

###################
# AWS DB Proxy
###################
resource "aws_db_proxy" "rds_db_proxy" {
  name                = "${local.db_name}-rds-db-proxy"
  debug_logging       = false
  engine_family       = "POSTGRESQL"
  idle_client_timeout = var.proxy_idle_client_timeout
  require_tls         = true
  role_arn            = aws_iam_role.rds_db_proxy_role.arn
  vpc_security_group_ids = [
    aws_security_group.source_security_group.id,
    aws_security_group.rds-single-master.id,
  ]
  vpc_subnet_ids = data.aws_subnets.application_subnets.ids

  auth {
    auth_scheme = "SECRETS"
    iam_auth    = "REQUIRED"
    secret_arn  = module.ssm_credentials.secrets_arn
  }
  tags = var.tags
}

resource "aws_db_proxy_default_target_group" "rds_db_proxy_defaut_target_group" {
  db_proxy_name = aws_db_proxy.rds_db_proxy.name

  connection_pool_config {
    max_connections_percent      = var.max_connections_percent
    max_idle_connections_percent = var.max_idle_connections_percent
  }
}

resource "aws_db_proxy_target" "rds_db_proxy_target" {
  db_instance_identifier = aws_db_instance.postgresql.identifier
  db_proxy_name          = aws_db_proxy.rds_db_proxy.name
  target_group_name      = aws_db_proxy_default_target_group.rds_db_proxy_defaut_target_group.name
}