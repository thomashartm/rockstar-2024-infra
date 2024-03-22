variable "name" {
  description = "Technical name of the webapp and the ecs cluster."
  type        = string
}

variable "region" {
  description = "Region where the log files should pre provided."
  type        = string
  default     = "eu-central-1"
}

variable "host_port" {
  description = "Port the webapp is listening on."
  type        = number
  default     = 8080
}

variable "alb_domain" {
  description = "Technical domain of the service exposed in the ecs cluster."
  type        = string
}

variable cloudfront_domain {
  type        = string
  description = "Domain of the ALBs certificate"
}

variable "hosted_zone" {
  description = "Hosted zone for DNS purposes."
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


variable "logs_retention_in_days" {
  type        = number
  default     = 30
  description = "Specifies the number of days you want to retain log events"
}

variable "health_check_path" {
  type        = string
  description = "Health check path"
  default     = "/api/status"
}