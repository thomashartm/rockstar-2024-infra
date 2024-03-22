variable "name" {
  description = "Name of the stack, e.g. \"app-yxz\""
}

variable "tags" {
  type        = map(any)
  description = "Tags associated with the solution"
}

variable "environment" {
  description = "The name of your environment or stage, e.g. \"prod\", \"int\", \"prod\""
}

variable "subnets" {
  description = "Comma separated list of subnet IDs"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "alb_security_groups" {
  description = "Comma separated list of security groups"
}

variable "alb_tls_cert_arn" {
  description = "The ARN of the certificate that the ALB uses for https"
}

variable "health_check_path" {
  description = "Path to check if the service is healthy, e.g. \"/status\""
}

variable "host_port" {
  description = "Host Port where application healthheck is exposed."
  type = number
  default = 80
}

variable "health_check_port" {
  description = "Host Port where application healthheck is exposed."
  type = number
  default = 80
}

variable "akamai_access_header_name" {
  type        = string
  default     = null
  description = "specifies the origin access identity header name shared with the Akamai property"
}

variable "akamai_access_header_value" {
  type        = string
  default     = null
  description = "specifies the origin access identity header value shared with the Akamai property"
}

variable "healthy_threshold" {
  type = string
  default = "2"
}

variable "health_check_interval" {
  type = string
  default = "30"
}

variable "unhealthy_threshold" {
  type = string
  default = "3"
}