output "certificate_arn" {
  value       = aws_acm_certificate.certificate.arn
  description = "ARN of the certificate"
}

output "certificate_id" {
  value       = aws_acm_certificate.certificate.id
  description = "ID of the certificate"
}

output "certificate_domain" {
  value       = aws_acm_certificate.certificate.domain_name
  description = "Domain of the certificate"
}

output "route53_record" {
  value = {
  for dns, details in aws_route53_record.cname_record:
  dns => ({ fqdn = details.fqdn , zone_id = details.zone_id , records = details.records})
  }

  description = "details of route53 CNAME record"
}
