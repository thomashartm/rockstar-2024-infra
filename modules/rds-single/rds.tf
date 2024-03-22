##################
# AWS DB Instance
###################
resource "aws_db_subnet_group" "db_subnet" {
  #count = var.create_db_subnet_group ? 1 : 0
  name        = local.internal_db_subnet_group_name
  description = "For RDS single instance DB ${local.db_name}"
  subnet_ids  = data.aws_subnets.application_subnets.ids

  tags = var.tags
}

resource "aws_security_group" "source_security_group" {
  #count                  = var.create_source_sg  ? 1 : 0
  name                   = "to-rds-${local.db_name}-sg"
  description            = "Access to RDS from application security groups"
  revoke_rules_on_delete = true
  vpc_id                 = data.aws_vpc.application_vpc.id

  ingress {
    from_port       = var.from_port_sg
    protocol        = "tcp"
    to_port         = var.to_port_sg
    security_groups = data.aws_security_groups.application_groups.ids
  }
  tags = var.tags
}

resource "aws_db_parameter_group" "db_parameter_group" {
  name   = "${var.stage}-rds-db-parameter-group"
  family = var.param_group_family

  parameter {
    name  = "log_min_duration_statement"
    value = 100
  }

  parameter {
    name  = "log_statement"
    value = "none"
  }
  tags = var.tags
}

resource "aws_db_instance" "postgresql" {
  engine                              = "postgres"
  db_name                             = local.db_name
  identifier                          = local.db_name
  # engine and port
  engine_version                      = var.engine_version
  port                                = var.database_port
  username                            = random_string.master_user.result
  password                            = random_password.master_password.result
  iam_database_authentication_enabled = false
  # db configs and upgrade behaviour
  instance_class                      = var.instance_type
  storage_type                        = var.storage_type
  allocated_storage                   = var.allocated_storage
  iops                                = var.iops
  auto_minor_version_upgrade          = var.auto_minor_version_upgrade
  # backup
  snapshot_identifier                 = var.snapshot_identifier
  final_snapshot_identifier           = var.final_snapshot_identifier
  skip_final_snapshot                 = var.skip_final_snapshot
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  backup_retention_period             = var.backup_retention_period
  backup_window                       = var.backup_window
  maintenance_window                  = var.maintenance_window
  multi_az                            = var.multi_availability_zone
  # networking
  vpc_security_group_ids              = [
    aws_security_group.source_security_group.id, aws_security_group.rds-single-master.id
  ]
  db_subnet_group_name                  = aws_db_subnet_group.db_subnet.name
  parameter_group_name                  = aws_db_parameter_group.db_parameter_group.name
  # storage
  storage_encrypted                     = var.storage_encrypted
  # monitoring and governance
  monitoring_interval                   = var.monitoring_interval
  monitoring_role_arn                   = var.monitoring_interval > 0 ? aws_iam_role.monitoring_role.arn : ""
  deletion_protection                   = var.deletion_protection
  enabled_cloudwatch_logs_exports       = var.cloudwatch_logs_exports
  tags                                  = var.tags
  publicly_accessible                   = true
  performance_insights_enabled          = true
  performance_insights_retention_period = 7 # 7 days of performance data history at no charge
}

module "ssm_credentials" {
  source         = "../ssm_credentials"
  stage          = var.stage
  description    = "SSM credentials for the RDS instance ${local.db_name}"
  name           = "${local.db_name}-credentials"
  username       = random_string.master_user.result
  password       = random_password.master_password.result
  db_host        = aws_db_instance.postgresql.endpoint
  db_host_reader = aws_db_instance.postgresql.endpoint
  db_port        = aws_db_instance.postgresql.port
  db_name        = local.db_name
  tags           = var.tags
}
