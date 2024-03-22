resource "aws_lb" "alb" {
  name               = "${var.name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_security_groups
  subnets            = var.subnets

  enable_deletion_protection = false

  tags = merge({
    Name        = "${var.name}-${var.environment}-alb"
    Environment = var.environment
  }, var.tags)
}

resource "aws_alb_target_group" "alb_tg" {
  name        = "${var.name}-tg-${var.environment}"
  port        = var.host_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    interval            = var.health_check_interval
    protocol            = "HTTP"
    matcher             = "200-302"
    port                = var.health_check_port
    path                = var.health_check_path
  }

  tags = merge({
    Name        = "${var.name}-${var.environment}-tg"
    Environment = var.environment
  }, var.tags)
}

# Redirect to https listener
resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.alb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Redirect traffic to 404 by default. The actual routing to the target will be done by listener rules.
resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_lb.alb.id
  port              = 443
  protocol          = "HTTPS"

  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.alb_tls_cert_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Page not found"
      status_code  = "404"
    }
  }
}
