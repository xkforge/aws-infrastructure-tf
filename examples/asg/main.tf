provider "aws" {
  region = "us-east-1"
}

module "asg" {
  source = "../../modules/asg"

  name               = "web-server"
  ami_id             = "ami-0c55b159cbfafe1f0"
  instance_type      = "t3.small"
  security_group_ids = ["sg-0123456789abcdef0"]
  subnet_ids         = ["subnet-aaa111", "subnet-bbb222"]

  min_size         = 1
  max_size         = 4
  desired_capacity = 2

  health_check_type         = "EC2"
  health_check_grace_period = 300

  enable_scaling_policy  = true
  target_cpu_utilization = 70

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
  EOF

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

output "asg_name" {
  value = module.asg.asg_name
}
