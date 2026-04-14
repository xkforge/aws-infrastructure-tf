# ALB Module

Terraform module for creating an AWS Application Load Balancer with target group, health checks, and configurable listener default actions.

## Features

- Internet-facing Application Load Balancer
- Target group with configurable health checks
- HTTP listener with configurable default actions (redirect, forward, fixed response)
- HTTPS listener with configurable default actions (forward, redirect, fixed response)
- HTTPS listener with ACM certificate (TLS 1.3 policy by default)
- Drop invalid HTTP headers enabled by default
- Optional access logging to S3

## Usage

### Basic usage (defaults: HTTP redirects to HTTPS, HTTPS forwards to module target group)

```hcl
module "alb" {
  source = "git::https://github.com/xkforge/aws-infrastructure-tf.git//modules/alb?ref=v1.0.0"

  name               = "my-app-alb"
  vpc_id             = "vpc-0123456789abcdef0"
  subnet_ids         = ["subnet-aaa", "subnet-bbb"]
  security_group_ids = ["sg-0123456789abcdef0"]
  certificate_arn    = "arn:aws:acm:us-east-1:123456789012:certificate/abc-123"

  health_check = {
    path    = "/health"
    matcher = "200-299"
  }

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

### Custom listener actions

```hcl
module "alb" {
  source = "git::https://github.com/xkforge/aws-infrastructure-tf.git//modules/alb?ref=v1.0.0"

  name               = "my-app-alb"
  vpc_id             = "vpc-0123456789abcdef0"
  subnet_ids         = ["subnet-aaa", "subnet-bbb"]
  security_group_ids = ["sg-0123456789abcdef0"]
  certificate_arn    = "arn:aws:acm:us-east-1:123456789012:certificate/abc-123"

  # HTTP -> custom redirect
  http_listener_default_actions = [
    {
      type = "redirect"
      redirect = {
        protocol    = "HTTPS"
        port        = "443"
        status_code = "HTTP_301"
      }
    }
  ]

  # HTTPS -> custom fixed response
  https_listener_default_actions = [
    {
      type = "fixed-response"
      fixed_response = {
        content_type = "application/json"
        message_body = "{\"message\":\"service unavailable\"}"
        status_code  = "503"
      }
    }
  ]

  tags = {
    Environment = "staging"
    ManagedBy   = "terraform"
  }
}
```

### Forward to a specific target group ARN

By default, `forward` actions use the module target group ARN.  
If needed, you can override it explicitly with `target_group_arn`:

```hcl
https_listener_default_actions = [
  {
    type             = "forward"
    target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/external-tg/abc123def456"
  }
]
```

## Listener Default Actions

Both listener action variables support these action types:

- `redirect`
- `forward`
- `fixed-response`

### Notes

- For `type = "forward"`, if `target_group_arn` is omitted, the module automatically uses `aws_lb_target_group.this.arn`.
- `fixed_response` is the Terraform attribute name, while the AWS action `type` remains `"fixed-response"`.
- Ensure action fields match the selected `type` (for example, provide `redirect` object when `type = "redirect"`).

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `name` | Name of the ALB | `string` | — | yes |
| `security_group_ids` | Security group IDs for the ALB | `list(string)` | — | yes |
| `subnet_ids` | Subnet IDs (minimum 2 AZs) | `list(string)` | — | yes |
| `vpc_id` | VPC ID for the target group | `string` | — | yes |
| `certificate_arn` | ACM certificate ARN for HTTPS | `string` | — | yes |
| `enable_deletion_protection` | Enable deletion protection | `bool` | `false` | no |
| `enable_access_logs` | Enable S3 access logging | `bool` | `false` | no |
| `access_logs_bucket` | S3 bucket for access logs | `string` | `null` | no |
| `access_logs_prefix` | S3 key prefix for access logs | `string` | `""` | no |
| `target_group_port` | Target group port | `number` | `80` | no |
| `target_group_protocol` | Target group protocol (`HTTP`, `HTTPS`) | `string` | `"HTTP"` | no |
| `target_type` | Target type (`instance`, `ip`, `lambda`, `alb`) | `string` | `"instance"` | no |
| `health_check` | Health check configuration object | `object` | See defaults | no |
| `listener_port` | HTTP listener port | `number` | `80` | no |
| `ssl_policy` | SSL policy for HTTPS listener | `string` | `"ELBSecurityPolicy-TLS13-1-2-2021-06"` | no |
| `drop_invalid_header_fields` | Drop invalid HTTP headers | `bool` | `true` | no |
| `http_listener_default_actions` | Default actions for HTTP listener | `list(object)` | Redirect HTTP to HTTPS | no |
| `https_listener_default_actions` | Default actions for HTTPS listener | `list(object)` | Forward to module target group | no |
| `tags` | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `alb_id` | ID of the ALB |
| `alb_arn` | ARN of the ALB |
| `alb_dns_name` | DNS name of the ALB |
| `alb_zone_id` | Canonical hosted zone ID (for Route 53) |
| `target_group_arn` | ARN of the target group |
| `http_listener_arn` | ARN of the HTTP listener |
| `https_listener_arn` | ARN of the HTTPS listener |
