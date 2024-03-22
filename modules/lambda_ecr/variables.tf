variable "database_access_policy_arn" {
  type        = string
  description = "ARN of the database access policy already created"
}

variable "env_vars" {
  type        = map(any)
  description = "Database environment variables including db connection and other data needed by the lambda"
}


variable "function_name" {
  description = "Name of the lambda function"
  type        = string
}

variable "function_description" {
  description = "Description of the lambda function"
  type        = string
}

variable "handler" {
  description = "Entry point for the lambda."
  type        = string
}

variable "lambda_layer_arns" {
  description = "ARNS of the layers applied to this lambda"
  type        = list(string)
}

variable "region" {
  description = "Execution region"
  type        = string
}

variable "runtime" {
  description = "Runtime of the lambda function"
  type        = string
  default     = "python3.11"
}

variable "ecr_image_name" {
  description = "name of the image in the accounts ecr repo"
  type        = string
}

variable "image_version" {
  description = "image version"
  type        = string
  default     = "latest"
}

variable "stage" {
  description = "Stage of the lambda function, normally dev, test, int, prod or developerid"
  type        = string
}

variable "tags" {
  type        = map(any)
  description = "Extra tags attached to the resources"
}

##########################
# Lambda resources
##########################
variable "timeout" {
  description = "Timeout in seconds for the lambda function"
  type        = number
  default     = 10
}

variable "memory_size" {
  description = "Memory size in MB for the lambda function"
  type        = number
  default     = 128
}

##########################
# VPC and networking
##########################
variable "vpc_tag" {
  type = string
}

variable "security_group_names" {
  type        = list(string)
  description = "List of VPC security group names to associate to the cluster in addition to the SG we create in this solution"
}

variable "subnet_tags" {
  type        = list(string)
  description = "A list of tags identifying a private subnet which hosts the application"
}
