resource "aws_ecs_service" "app_service" {
  name                               = "${var.name}-${var.environment}-service"
  cluster                            = var.cluster_id
  task_definition                    = var.task_definition
  desired_count                      = var.service_desired_count
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds


  launch_type             = "FARGATE"
  scheduling_strategy     = "REPLICA"
  force_new_deployment    = true
  enable_ecs_managed_tags = true
  propagate_tags          = "SERVICE"

  network_configuration {
    security_groups  = var.service_security_group_ids
    subnets          = var.service_subnet_ids
    # we disable it by default. Public Ips without any LB or API GW are not intended to be supported in our stacks
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  # we ignore task_definition changes as the revision  when a new version of the application is deployed
  # autoscaling policy might me different then desired_count so better we ignore it
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }

  tags = merge({
    Name        = "${var.name}-service-${var.environment}"
    Environment = var.environment
  }, var.tags)
}

resource "aws_appautoscaling_target" "ecs_autoscaling_target" {
  max_capacity       = var.max_auto_scaling_capacity
  min_capacity       = var.min_auto_scaling_capacity
  resource_id        = "service/${var.cluster_id}/${aws_ecs_service.app_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


resource "aws_appautoscaling_policy" "ecs_memory_policy" {
  name               = "${var.name}-ecs-memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_autoscaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_autoscaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_autoscaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = "${var.name}-ecs-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_autoscaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_autoscaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_autoscaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 60
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}