locals {

  # Sort environment variables so terraform will not try to recreate on each plan/apply
  env_vars_keys        = var.map_env != null ? keys(var.map_env) : var.container_environment != null ? [for m in var.container_environment : lookup(m, "name")] : []
  env_vars_values      = var.map_env != null ? values(var.map_env) : var.container_environment != null ? [for m in var.container_environment : lookup(m, "value")] : []
  env_vars_as_map      = zipmap(local.env_vars_keys, local.env_vars_values)
  sorted_env_vars_keys = sort(local.env_vars_keys)

  sorted_environment_vars = [
  for key in local.sorted_env_vars_keys :
  {
    name  = key
    value = lookup(local.env_vars_as_map, key)
  }
  ]

  # Sort secrets so terraform will not try to recreate on each plan/apply
  secrets_keys        = var.map_secrets != null ? keys(var.map_secrets) : var.secrets != null ? [for m in var.secrets : lookup(m, "name")] : []
  secrets_values      = var.map_secrets != null ? values(var.map_secrets) : var.secrets != null ? [for m in var.secrets : lookup(m, "valueFrom")] : []
  secrets_as_map      = zipmap(local.secrets_keys, local.secrets_values)
  sorted_secrets_keys = sort(local.secrets_keys)

  sorted_secrets_vars = [
  for key in local.sorted_secrets_keys :
  {
    name      = key
    valueFrom = lookup(local.secrets_as_map, key)
  }
  ]

  final_environment_vars = length(local.sorted_environment_vars) > 0 ? local.sorted_environment_vars : null
  final_secrets_vars     = length(local.sorted_secrets_vars) > 0 ? local.sorted_secrets_vars : null

  container_definition = {
    name      = var.container_name
    image     = var.image
    essential = true
    command   = var.command
    portMappings = [
      {
        protocol      = "tcp"
        containerPort = var.container_port
        hostPort      = var.host_port
      }, {
        protocol      = "tcp"
        containerPort = var.healthcheck_container_port
        hostPort      = var.healthcheck_host_port
      }
    ]

    linuxParameters: {
      initProcessEnabled: true
    }

    logConfiguration = {
      logDriver = "awslogs"
      options   = {
        awslogs-group         = aws_cloudwatch_log_group.app_log_group.name
        awslogs-stream-prefix = "ecs"
        awslogs-region        = var.region
      }
    }

    environment            = local.final_environment_vars
    secrets                = local.final_secrets_vars
  }

  container_definition_without_null = {
    for k, v in local.container_definition :
    k => v
    if v != null
  }

  # maps local container_definition with override container_definition
  container_json_map = jsonencode(merge(local.container_definition_without_null, var.container_definition))
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.name}-${var.environment}-ecs-taskExecutionRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.name}-${var.environment}-ecs-taskRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs-task-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "app_log_group" {
  name = "/aws/ecs/fargate/${var.name}-task-${var.environment}"

  retention_in_days = var.logs_retention_in_days

  tags = merge({
    Name        = "${var.name}-task-logs-${var.environment}"
    Environment = var.environment
  }, var.tags)
}

resource "aws_ecs_task_definition" "app_task" {
  family                   = "${var.name}-${var.environment}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_container_cpu
  memory                   = var.task_container_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = "[${local.container_json_map}]"

  dynamic "volume" {
    for_each = var.volumes
    content {
      name = volume.value.name

      host_path = lookup(volume.value, "host_path", null)

      dynamic "docker_volume_configuration" {
        for_each = lookup(volume.value, "docker_volume_configuration", [])
        content {
          autoprovision = lookup(docker_volume_configuration.value, "autoprovision", null)
          driver        = lookup(docker_volume_configuration.value, "driver", null)
          driver_opts   = lookup(docker_volume_configuration.value, "driver_opts", null)
          labels        = lookup(docker_volume_configuration.value, "labels", null)
          scope         = lookup(docker_volume_configuration.value, "scope", null)
        }
      }

      dynamic "efs_volume_configuration" {
        for_each = lookup(volume.value, "efs_volume_configuration", [])
        content {
          file_system_id          = lookup(efs_volume_configuration.value, "file_system_id", null)
          root_directory          = lookup(efs_volume_configuration.value, "root_directory", null)
          transit_encryption      = lookup(efs_volume_configuration.value, "transit_encryption", null)
          transit_encryption_port = lookup(efs_volume_configuration.value, "transit_encryption_port", null)
          dynamic "authorization_config" {
            for_each = lookup(efs_volume_configuration.value, "authorization_config", [])
            content {
              access_point_id = lookup(authorization_config.value, "access_point_id", null)
              iam             = lookup(authorization_config.value, "iam", null)
            }
          }
        }
      }
    }
  }

  tags = merge({
    Name        = "${var.name}-task-${var.environment}"
    Environment = var.environment
  }, var.tags)
}

resource "aws_iam_role_policy_attachment" "task_role_attachment" {
  for_each = var.task_policy_attachments
  policy_arn = each.value
  role       = aws_iam_role.ecs_task_role.name
}

resource "aws_iam_role_policy_attachment" "task_execution_role_attachment" {
  for_each = var.task_execution_policy_attachments
  policy_arn = each.value
  role       = aws_iam_role.ecs_task_execution_role.name
}