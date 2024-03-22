output "hosted_zone_id" {
  value = aws_cloudfront_distribution.cdn_delivery.hosted_zone_id
}

output "domain_name" {
  value = aws_cloudfront_distribution.cdn_delivery.domain_name
}