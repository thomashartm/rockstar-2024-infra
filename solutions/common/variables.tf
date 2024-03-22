variable "tags" {
  type        = map(any)
  description = "Extra tags attached to the resources"
}

###### ACM Certificate
variable "domain" {
  description = "Certificate domain to be created for infrastructure records."
  type        = string
}

variable "cloudfront_domain" {
  description = "Certificate domain to be created for infrastructure records."
  type        = string
}

variable "hosted_zone" {
  description = "Hosted zone for domain registration"
  type        = string
}

variable "acm_region" {
  description = "Region where the certificate is located."
  type        = string
  default     = "eu-central-1"
}

variable "alternatives_subdomains" {
  description = "Should a wildcard subdomain be created."
  type        = list
}

variable "alternatives_subdomains_cf" {
  description = "Should a wildcard subdomain be created."
  type        = list
}

variable "api_credential_secret" {
  description = "The secret name for the API credentials"
  type        = object({
    name        = string
    description = string
  })
  default = {
    name        = "summitchataem-api-credentials"
    description = "API credentials for the chat aem application"
  }
}

variable "environment" {
  type        = string
  description = "Name of the environment the service is operation in. Can be for instance test, int or prod"
}
