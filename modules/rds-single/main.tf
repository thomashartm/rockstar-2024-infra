locals {
  db_name                       = var.db_instance_name
  internal_db_subnet_group_name = "${var.db_instance_name}_dbsubnet_group"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "random_string" "master_user" {
  length  = 16
  numeric = false
  special = false
}

resource "random_password" "master_password" {
  length           = 35
  special          = true
  override_special = "!#%*-_+?"
}

###################
# IAM resources
###################
data "aws_iam_policy_document" "rds_monitoring_policy_doc" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "monitoring_role" {
  name               = "rds-${local.db_name}-monitoring-role"
  assume_role_policy = data.aws_iam_policy_document.rds_monitoring_policy_doc.json
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "monitoring_policy_role_attachment" {
  role       = aws_iam_role.monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

###################
# VPC Networking
###################
data "aws_vpc" "application_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_tag]
  }
}

data "aws_subnets" "application_subnets" {
  filter {
    name   = "tag:Name"
    values = var.subnet_tags
  }
}

resource "aws_security_group" "rds-single-master" {
  vpc_id      = data.aws_vpc.application_vpc.id
  name_prefix = "${local.db_name}-rds-sg"

  ingress {
    description = "Allow DB accepts connections to this Port"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outgoing traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name        = "sg-${local.db_name}-rds"
      Application = var.db_instance_name,
      Environment = var.stage
    },
    var.tags
  )
}

data "aws_security_groups" "application_groups" {
  filter {
    name   = "group-name"
    values = var.security_group_names
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.application_vpc.id]
  }
}

