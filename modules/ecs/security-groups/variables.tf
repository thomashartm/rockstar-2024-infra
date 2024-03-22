variable "name" {
  description = "Name of your stack, e.g. webapp"
}

variable "description" {
  description = "Description of your stack, e.g. Web Application"
  default     = "Managed by Terraform"
}

variable "environment" {
  description = "The stage of the environment, e.g. prod"
}

variable "vpc_id" {
  description = "The VPC ID"
}

variable "revoke_rules_on_delete" {
  description = "Add option to forcefully revoke rules before deletion."
  type        = bool
  default     = true
}

variable "ingress_rules" {
  description = "Inbound data flow rules"
  type        = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    description      = string
  }))

  default = [
    {
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "Default ingress rule allowing traffic on port 80"
    },
    {
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "Default ingress rule allowing traffic on port 443"
    }
  ]
}

variable "egress_rules" {
  description = "Outbound data flow rules"
  type        = list(object({
    protocol         = string
    from_port        = number
    to_port          = number
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    description      = string
  }))

  default = [
    {
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = "Default egress rule allowing all outgoing traffic"
    }
  ]
}

variable "tags" {
  type        = map(any)
  description = "Tags associated with the ecs cluster"
}