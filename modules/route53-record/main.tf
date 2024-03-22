provider "aws" {
  alias      = "route53_provider"
  region     = var.route_region
}

data "aws_route53_zone" "amg_hosted_zone" {
  name         = var.hosted_zone_name
  private_zone = false
}

resource "aws_route53_record" "origin" {
  provider    = aws.route53_provider
  zone_id     = data.aws_route53_zone.amg_hosted_zone.zone_id
  name        = var.record_domain_name
  type        = "A"

  alias {
    name      = var.alias_record_domain_name
    zone_id   = var.alias_hosted_zone_id
    evaluate_target_health = false
  }
}