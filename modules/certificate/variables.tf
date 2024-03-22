variable "domain" {
  description = "Certificate domain to be created for infrastructure records."
  type = string
}

variable "hosted_zone" {
  description = "Hosted zone for domain registration"
  type = string
}

variable "acm_region" {
  description = "Region where the certificate is located."
  type = string
  default = "eu-central-1"
}

variable "alternatives_subdomains" {
  description = "Should a wildcard subdomain be created."
  type = list
}

variable "tags" {
  type        = map(any)
  description = "Tags associated with the certificate"
}
