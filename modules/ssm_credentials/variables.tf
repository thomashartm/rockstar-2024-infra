variable "name" {
  type        = string
  description = "Secret's name"
}
variable "description" {
  type        = string
  description = "Secret's description"
}
variable "stage" {
  type        = string
  description = "Stage we are operating in. Is used in the secrets naming pattern"
}

variable "tags" {
  type        = map(any)
  description = "Tags associated with the certificate"
}

variable "db_host" {
  type        = string
  description = "Database master hostname"
}

variable "db_host_reader" {
  type        = string
  description = "Reader hostname"
}

variable "db_port" {
  type        = number
  description = "Database port"
}

variable "username" {
  type        = string
  description = "Username to store"
}

variable "password" {
  type        = string
  description = "Password to store"
}

variable "db_name" {
  type        = string
  description = "Database Name"
}