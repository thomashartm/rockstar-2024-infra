variable "name" {
  description = "Name of the ECS App. It is used in the cluster, service and task definition."
  type = string
}

variable "region" {
  description = "Region where the log files should pre provided."
  type = string
  default = "eu-central-1"
}

variable "environment" {
  description = "Name of the environment (stage)."
  type = string
}

variable "tags" {
  type        = map(any)
  description = "Tags associated with the ecs cluster"
}

variable "command" {
  type        = list(string)
  description = "The command that is passed to the container"
  default     = null
}

variable "container_definition" {
  type        = map(any)
  description = "Container definition overrides which allows for extra keys or overriding existing keys."
  default     = {}
}

variable "container_port" {
  description = "Container Port where application is exposed."
  type = number
  default = 8080
}

variable "host_port" {
  description = "Host Port where application is exposed."
  type = number
  default = 8080
}

variable "healthcheck_container_port" {
  description = "Container Port where application is exposed."
  type = number
  default = 8081
}

variable "healthcheck_host_port" {
  description = "Host Port where application is exposed."
  type = number
  default = 8081
}

variable "task_container_cpu" {
  description = "The number of cpu units used by the task"
  type = number
  default = 256
}

variable "task_container_memory" {
  description = "The amount (in MiB) of memory used by the task"
  type = number
  default = 512
}

variable "container_name" {
  description = "Docker container_name to be launched"
  type = string
}

variable "image" {
  description = "Docker image and version tag to be launched"
  type = string
}

variable "container_secrets" {
  description = "The container secret environment variables"
  type        = list(string)
  default = null
}

variable "container_secrets_arns" {
  description = "ARN for secrets"
  type = list(string)
  default = null
}

variable "logs_retention_in_days" {
  type        = number
  default     = 30
  description = "Specifies the number of days you want to retain log events"
}


variable "container_environment" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "The env variables to pass to the container. This is a list of maps. map_env overrides environment"
  default     = []
}

variable "map_env" {
  type        = map(string)
  description = "The environment variables to pass to the container. This is a map of string: {key: value}. map_env overrides environment"
  default     = null
}

variable "map_secrets" {
  type        = map(string)
  description = "The secrets variables to pass to the container. This is a map of string: {key: value}. map_secrets overrides secrets"
  default     = null
}

variable "secrets" {
  type = list(object({
    name      = string
    valueFrom = string
  }))
  description = "The secrets to pass to the container. This is a list of maps"
  default     = []
}

variable "volumes" {
  description = "(Optional) A set of volume blocks that containers in the task definition may use"
  type = list(object({
    host_path = string
    name      = string
    docker_volume_configuration = list(object({
      autoprovision = bool
      driver        = string
      driver_opts   = map(string)
      labels        = map(string)
      scope         = string
    }))
    efs_volume_configuration = list(object({
      file_system_id          = string
      root_directory          = string
      transit_encryption      = string
      transit_encryption_port = string
      authorization_config = list(object({
        access_point_id = string
        iam             = string
      }))
    }))
  }))
  default = []
}