variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "vpcChat"
}

variable "tags" {
  type        = map(any)
  description = "Extra tags attached to the resources"
}

variable "vpc_tag" {
  description = "The tag to use for the VPC"
  type        = string
  default     = "vpcChat"
}

variable "public_subnet_tag" {
  description = "The tag to use for the VPC"
  type        = string
  default     = "publicSubnetChatAem"
}

variable "private_subnet_tag" {
  description = "The tag to use for the VPC"
  type        = string
  default     = "privateSubnetChatAem"
}

variable "database_subnet_tag" {
  description = "The tag to use for the VPC"
  type        = string
  default     = "databaseSubnetChatAem"
}

variable "azs" {
  description = "The availability zones to use"
  type        = list(string)
  default     = ["eu-central-1a"]
}

variable "private_subnets" {
  description = "The private subnets to create"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "The public subnets to create"
  type        = list(string)
  default     = []
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway"
  type        = bool
  default     = true
}

variable "enable_vpn_gateway" {
  description = "Enable VPN Gateway"
  type        = bool
  default     = false
}

variable "internal_sg_group_name" {
  description = "Technical name of the webapp and the ecs cluster."
  type        = string
}

variable "environment" {
  type        = string
  description = "Name of the environment the service is operation in. Can be for instance test, int or prod"
}

variable "internal_sg_ingress_rules" {
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    description      = string
    ipv6_cidr_blocks = list(string)
  }))
  description = "List of ingress rules for the security group"
  default     = []
}

variable "internal_sg_egress_rules" {
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    description      = string
    ipv6_cidr_blocks = list(string)
  }))
  description = "List of egress rules for the security group"
  default     = []
}
