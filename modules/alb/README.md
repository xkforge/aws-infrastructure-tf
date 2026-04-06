# ALB Module

Terraform module for creating an AWS Application Load Balancer with target group, health checks, and HTTP/HTTPS listeners.

## Features

- Application Load Balancer (internet-facing or internal)
- Target group with configurable health checks
- HTTP listener with optional auto-redirect to HTTPS
- Conditional HTTPS listener with ACM certificate
- Optional access logging to S3

## Usage

### HTTP Only

```hcl
module "alb" {
  source = "git::https://github.com/xkforge/aws-infrastructure-tf.git//modules/alb?ref=v1.0.0"

  name               = "my-app-alb"
  vpc_id             = "vpc-0123456789abcdef0"
  subnet_ids         = ["subnet-aaa", "subnet-bbb"]
  security_group_ids = ["sg-0123456789abcdef0"]

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

### With HTTPS

```hcl
module "alb" {
  source = "git::https://github.com/xkforge/aws-infrastructure-tf.git//modules/alb?ref=v1.0.0"

  name               = "my-app-alb"
  vpc_id             = "vpc-0123456789abcdef0"
  subnet_ids         = ["subnet-aaa", "subnet-bbb"]
  security_group_ids = ["sg-0123456789abcdef0"]
  certificate_arn    = "arn:aws:acm:us-east-1:123456789012:certificate/abc-123"

  tags = {
    Environment = "production"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `name` | Name of the ALB | `string` | — | yes |
| `internal` | Whether the ALB is internal | `bool` | `false` | no |
| `security_group_ids` | Security group IDs for the ALB | `list(string)` | — | yes |
| `subnet_ids` | Subnet IDs (minimum 2 AZs) | `list(string)` | — | yes |
| `vpc_id` | VPC ID for the target group | `string` | — | yes |
| `enable_deletion_protection` | Enable deletion protection | `bool` | `false` | no |
| `enable_access_logs` | Enable S3 access logging | `bool` | `false` | no |
| `access_logs_bucket` | S3 bucket for access logs | `string` | `null` | no |
| `access_logs_prefix` | S3 key prefix for access logs | `string` | `""` | no |
| `target_group_port` | Target group port | `number` | `80` | no |
| `target_group_protocol` | Target group protocol (`HTTP`, `HTTPS`) | `string` | `"HTTP"` | no |
| `target_type` | Target type (`instance`, `ip`, `lambda`, `alb`) | `string` | `"instance"` | no |
| `health_check` | Health check configuration object | `object` | See defaults | no |
| `listener_port` | HTTP listener port | `number` | `80` | no |
| `certificate_arn` | ACM certificate ARN for HTTPS | `string` | `null` | no |
| `ssl_policy` | SSL policy for HTTPS listener | `string` | `"ELBSecurityPolicy-TLS13-1-2-2021-06"` | no |
| `drop_invalid_header_fields` | Drop invalid HTTP headers | `bool` | `true` | no |
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
| `https_listener_arn` | ARN of the HTTPS listener (null if no certificate) |
