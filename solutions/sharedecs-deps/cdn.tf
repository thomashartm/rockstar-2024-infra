resource "aws_cloudfront_function" "cloudfront_secure_access" {
  name    = "chataem_cloudfront_httpauth_access"
  runtime = "cloudfront-js-2.0"
  code    = file("function/index.js")
  comment = "Cloudfront function to secure access to the website"
}

resource "aws_cloudfront_key_value_store" "function_key_value_store" {
  name    = "chataem_cloudfront_httpauth_access"
  comment = "Key value store which stores the config for the cloudfront function"
}

module "cloudfront" {
  source             = "../../modules/cloudfront"
  certificate_domain = var.cloudfront_domain
  domain             = var.cloudfront_domain
  index_document     = ""
  origin_domain      = var.alb_domain
  function = {
    event_type   = "viewer-request"
    function_arn = aws_cloudfront_function.cloudfront_secure_access.arn
  }
}

module "app_domain_record" {
  source                   = "../../modules/route53-record"
  record_domain_name       = var.cloudfront_domain
  hosted_zone_name         = var.hosted_zone
  alias_hosted_zone_id     = module.cloudfront.hosted_zone_id
  alias_record_domain_name = module.cloudfront.domain_name
  # mandatory for cloudfront to create the DNS record in us-east-1
  route_region             = "us-east-1"
}