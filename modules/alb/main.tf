resource "aws_lb" "this" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = var.enable_deletion_protection
  drop_invalid_header_fields = var.drop_invalid_header_fields

  dynamic "access_logs" {
    for_each = var.enable_access_logs ? [1] : []

    content {
      bucket  = var.access_logs_bucket
      prefix  = var.access_logs_prefix
      enabled = true
    }
  }

  tags = merge(
    { Name = var.name },
    var.tags
  )
}

resource "aws_lb_target_group" "this" {
  name        = "${var.name}-tg"
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    enabled             = true
    healthy_threshold   = var.health_check.healthy_threshold
    unhealthy_threshold = var.health_check.unhealthy_threshold
    timeout             = var.health_check.timeout
    interval            = var.health_check.interval
    path                = var.health_check.path
    port                = var.health_check.port
    protocol            = var.health_check.protocol
    matcher             = var.health_check.matcher
  }

  tags = merge(
    { Name = "${var.name}-tg" },
    var.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.listener_port
  protocol          = "HTTP"

  dynamic "default_action" {
    for_each = var.http_listener_default_actions
    content {
      type = default_action.value.type

      dynamic "redirect" {
        for_each = default_action.value.type == "redirect" && try(default_action.value.redirect, null) != null ? [default_action.value.redirect] : []
        content {
          port        = try(redirect.value.port, null)
          protocol    = try(redirect.value.protocol, null)
          status_code = try(redirect.value.status_code, null)
          host        = try(redirect.value.host, null)
          path        = try(redirect.value.path, null)
          query       = try(redirect.value.query, null)
        }
      }
    }
  }

  tags = var.tags
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  dynamic "default_action" {
    for_each = var.https_listener_default_actions
    content {
      type = default_action.value.type

      target_group_arn = default_action.value.type == "forward" ? coalesce(
        try(default_action.value.target_group_arn, null),
        aws_lb_target_group.this.arn
      ) : null

      dynamic "fixed_response" {
        for_each = default_action.value.type == "fixed-response" && try(default_action.value.fixed_response, null) != null ? [default_action.value.fixed_response] : []
        content {
          content_type = try(fixed_response.value.content_type, null)
          message_body = try(fixed_response.value.message_body, null)
          status_code  = try(fixed_response.value.status_code, null)
        }
      }
    }
  }

  tags = var.tags
}
