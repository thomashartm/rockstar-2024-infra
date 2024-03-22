variable "name" {
  description = "Technical name of the webapp and the ecs cluster."
  type        = string
}

variable "tags" {
  type        = map(any)
  description = "Tags associated with the ecs cluster"
}

variable "environment" {
  type        = string
  description = "Name of the environment the service is operation in. Can be for instance test, int or prod"
}

variable vpc_tag {
  type        = string
  description = "tag of the vpc"
}

variable "alb_subnet_tags" {
  type        = list(string)
  description = "Tags that uniquely identify the associated alb subnets. Should be public."
}

variable "ecs_subnet_tags" {
  type        = list(string)
  description = "Tags that uniquely identify the associated ecs subnets. Should be private."
}

variable "cluster_name" {
  description = "Technical name of the ecs cluster."
  type        = string
}

variable "lb_tg_arn" {
  description = "The arn of the load balancer target group"
  type        = string
}

variable "lb_listener_arn" {
  description = "The arn of the load balancer listener"
  type        = string
}


variable "container_port" {
  description = "Container Port where application is exposed."
  type        = number
  default     = 8080
}

variable "host_port" {
  description = "Host port where application is exposed."
  type        = number
  default     = 8080
}

variable "container_log_level" {
  description = "Container log level."
  type        = string
  default     = "DEBUG"
}

variable "container_name" {
  description = "Container name."
  type        = string
}

variable "container_image" {
  description = "Container image."
  type        = string
}

variable "container_image_version" {
  description = "Container image version."
  type        = string
  default     = "latest"
}

variable "container_cpu" {
  description = "The number of cpu units used by the task"
  type        = number
  default     = 256
}

variable "container_memory" {
  description = "The amount (in MiB) of memory used by the task"
  type        = number
  default     = 512
}

variable "service_desired_count" {
  description = "Number of service instances running"
  type        = number
  default     = 1
}

variable "min_auto_scaling_capacity" {
  description = "Minimum capacity of the ecs autoscaling target"
  type        = number
  default     = 1
}

variable "max_auto_scaling_capacity" {
  description = "Maximum capacity of the ecs autoscaling target"
  type        = number
  default     = 1
}

variable "logs_retention_in_days" {
  type        = number
  default     = 30
  description = "Specifies the number of days you want to retain log events"
}

variable "allowed_secrets" {
  type        = list(string)
  description = "List of allowed secrets"
  default     = []
}

variable "db_secret_name" {
  description = "Container image."
  type        = string
}

variable "open_api_key_secret_name" {
  description = "Container image."
  type        = string
}

variable "param_lb_apikey_setting" {
  description = "Param Store setting namefor the CF to LB API Key"
  type        = string
  default     = "chataem-lb-api-key"
}