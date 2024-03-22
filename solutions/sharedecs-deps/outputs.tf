output "cluster_id" {
  value = module.ecs_cluster.cluster_id
}

output "lb_tg_name" {
  value = module.alb.aws_alb_target_group_name
}

output "lb_tg_arn" {
  value = module.alb.aws_alb_target_group_arn
}

output "lb_https_listener_arn" {
  value = module.alb.alb_https_listener_arn
}

output "lb_http_listener_arn" {
  value = module.alb.alb_http_listener_arn
}