module "alb_security_groups" {
  source                 = "../../modules/ecs/security-groups"
  name                   = "${var.name}-${var.environment}-alb-sg"
  environment            = var.environment
  vpc_id                 = data.aws_vpc.application_vpc.id
  tags                   = var.tags
  revoke_rules_on_delete = true
}

module "alb" {
  source              = "../../modules/alb/alb"
  name                = var.name
  tags                = var.tags
  environment         = var.environment
  vpc_id              = data.aws_vpc.application_vpc.id
  subnets             = toset(data.aws_subnets.alb_public.ids)
  alb_security_groups = [module.alb_security_groups.id]
  alb_tls_cert_arn    = data.aws_acm_certificate.certificate.arn
  health_check_path   = var.health_check_path
  health_check_port   = 8080
  host_port           = var.host_port
  depends_on          = [module.alb_security_groups]
}

module "alb_domain_record" {
  source                   = "../../modules/route53-record"
  record_domain_name       = var.alb_domain
  hosted_zone_name         = var.hosted_zone
  alias_hosted_zone_id     = module.alb.alb_zone_id
  alias_record_domain_name = module.alb.alb_dns_name
  route_region             = var.region
}
