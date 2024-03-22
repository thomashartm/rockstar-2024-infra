output "aws_alb_target_group_arn" {
  value = aws_alb_target_group.alb_tg.arn
}

output "aws_alb_target_group_name" {
  value = aws_alb_target_group.alb_tg.name
}

output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_http_listener_arn" {
  value = aws_alb_listener.http.arn
}

output "alb_https_listener_arn" {
  value = aws_alb_listener.https.arn
}
