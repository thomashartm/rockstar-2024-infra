variable "name" {
  description = "Name of the ECS App. It is used in the cluster, service and task definition."
  type = string
}

variable "environment" {
  description = "Name of the environment (stage)."
  type = string
}

variable "tags" {
  type        = map(any)
  description = "Tags associated with the ecs cluster"
}

variable "cluster_id" {
  description = "ID of the cluster the stack is running in."
  type = string
}

variable "task_definition" {
  description = "ECS Task definition which is executed with this service."
  type = string
}

variable "min_auto_scaling_capacity" {
  description = "Minimum capacity of the ecs autoscaling target"
  type = number
  default = 1
}

variable "max_auto_scaling_capacity" {
  description = "Maximum capacity of the ecs autoscaling target"
  type = number
  default = 1
}

variable "service_desired_count" {
  description = "Number of service instances running"
  type = number
  default = 1
}

variable "deployment_minimum_healthy_percent" {
  type        = number
  description = "Lower limit of healthy tasks as a percentage of the service's desiredCount."
  default     = 0
}

variable "deployment_maximum_percent" {
  type        = number
  description = "Upper limit, as a percentage of the service's desiredCount, of the number of running tasks that can be running in a service."
  default     = 200
}

variable "health_check_grace_period_seconds" {
  type        = number
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks."
  default     = 60
}

variable "service_security_group_ids" {
  type = list(string)
  description = "Security groups associated with the task or service."
}

variable "service_subnet_ids" {
  description = "Subnets associated with the task or service."
}

variable "alb_target_group_arn" {
  description = "ARN of the Load Balancer target group to associate with the service."
  type = string
}

variable "container_name" {
  description = "Docker container_name to be launched"
  type = string
}

variable "container_port" {
  description = "Container Port where application is exposed."
  type = number
  default = 80
}