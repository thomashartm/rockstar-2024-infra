# Provider needs to be defined here.
# We need to switch the region to us-east-1 if the certificate is going to be used in cloudfront.
provider "aws" {
  alias      = "acm_provider"
  region     = var.acm_region
}

data "aws_route53_zone" "hosted_zone" {
  name         = var.hosted_zone
  private_zone = false
}

resource "aws_route53_record" "cname_record" {
  for_each = {
  for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
    name   = dvo.resource_record_name
    record = dvo.resource_record_value
    type   = dvo.resource_record_type
  }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.hosted_zone.zone_id
}

resource "aws_acm_certificate" "certificate" {
  provider                  = aws.acm_provider
  domain_name               = var.domain
  subject_alternative_names = var.alternatives_subdomains
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
  tags = var.tags
}

resource "aws_acm_certificate_validation" "wildcard_cname_validation" {
  provider                = aws.acm_provider
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cname_record : record.fqdn]
}
