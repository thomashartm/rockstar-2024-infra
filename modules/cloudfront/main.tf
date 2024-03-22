###################################
# CloudFront Origin Access Identity
###################################
locals {
  log_bucket = "logs.${var.domain}"
  origin_id  = "chataem-alb-origin"
}

provider "aws" {
  alias  = "cf_provider"
  region = "us-east-1"
}

data "aws_acm_certificate" "cloudfront_certificate" {
  provider    = aws.cf_provider
  domain      = var.certificate_domain
  most_recent = true
}

###################################
# CloudFront
###################################

resource "aws_cloudfront_distribution" "cdn_delivery" {
  provider = aws.cf_provider
  enabled  = true
  #default_root_object = var.index_document
  aliases  = [var.domain]


  origin {
    domain_name = var.origin_domain
    origin_id   = local.origin_id
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2", "TLSv1.1"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["POST", "HEAD", "PATCH", "DELETE", "PUT", "GET", "OPTIONS"]
    cached_methods   = ["HEAD", "GET", "OPTIONS"]
    target_origin_id = local.origin_id

    # Managed policy to deny caching - to avoid authentication issues
    cache_policy_id          = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"

    # Managed policy allow query strings and cookies
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"

    viewer_protocol_policy   = "redirect-to-https"
    dynamic "function_association" {
      for_each = var.function != null ? ["function_association"] : []

      content {
        event_type   = lookup(var.function, "event_type", "viewer-request")
        function_arn = lookup(var.function, "function_arn", "")
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.cloudfront_certificate.arn
    minimum_protocol_version = "TLSv1"
    ssl_support_method       = "sni-only"
  }

}

resource "aws_s3_bucket" "cf_logs" {
  provider      = aws.cf_provider
  bucket        = local.log_bucket
  force_destroy = true
}
