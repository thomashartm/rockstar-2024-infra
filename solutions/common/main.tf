locals {
  region = data.aws_region.current.name
}

data "aws_region" "current" {}

module "certificate" {
  source                  = "../../modules/certificate"
  domain                  = var.domain
  hosted_zone             = var.hosted_zone
  alternatives_subdomains = var.alternatives_subdomains
  tags                    = var.tags
}

module "cloudfront_certificate" {
  source                  = "../../modules/certificate"
  domain                  = var.cloudfront_domain
  hosted_zone             = var.hosted_zone
  alternatives_subdomains = var.alternatives_subdomains_cf
  tags                    = var.tags
  acm_region              = "us-east-1"
}

resource "aws_secretsmanager_secret" "secret_credentials" {
  name                    = var.api_credential_secret.name
  tags                    = var.tags
  description             = var.api_credential_secret.description
  recovery_window_in_days = 0
}
