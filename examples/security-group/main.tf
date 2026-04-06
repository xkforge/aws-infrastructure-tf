provider "aws" {
  region = "us-east-1"
}

module "web_sg" {
  source = "../../modules/security-group"

  name        = "web-server-sg"
  description = "Security group for web servers"
  vpc_id      = "vpc-0123456789abcdef0"

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Allow HTTP"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allow HTTPS"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]

  egress_rules = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Allow HTTPS outbound"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

output "security_group_id" {
  value = module.web_sg.security_group_id
}
