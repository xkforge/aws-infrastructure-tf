provider "aws" {
  region = "us-east-1"
}

module "alb" {
  source = "../../modules/alb"

  name               = "my-app-alb"
  vpc_id             = "vpc-0123456789abcdef0"
  subnet_ids         = ["subnet-aaa111", "subnet-bbb222"]
  security_group_ids = ["sg-0123456789abcdef0"]
  certificate_arn    = "arn:aws:acm:us-east-1:123456789012:certificate/abc-def-123"

  target_group_port     = 8080
  target_group_protocol = "HTTP"

  health_check = {
    path                = "/health"
    matcher             = "200-299"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
