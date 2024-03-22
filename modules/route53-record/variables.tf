variable "record_domain_name" {
  description = "Name of the route53 record. Use the domain name here."
  type        = string
}

variable "hosted_zone_name" {
  description = "Name of the hosted zone"
  type        = string
}

variable "alias_record_domain_name" {
  description = "Alias name of the route53 record. Use the domain name here."
  type        = string
}

variable "alias_hosted_zone_id" {
  description = "Alias zone id of the hosted zone"
  type        = string
}

variable "route_region" {
  description = "Region to place the certificate in"
  type        = string
}