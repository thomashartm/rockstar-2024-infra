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
