# ASG Module

Terraform module for creating an AWS Auto Scaling Group with a launch template, configurable scaling policies, and ALB integration.

## Features

- Launch template with IMDSv2 enforced (security best practice)
- Tag propagation to instances and volumes
- Optional CPU-based target tracking scaling policy
- ALB target group attachment
- Ignores `desired_capacity` drift from manual/auto scaling

## Usage

```hcl
module "asg" {
  source = "git::https://github.com/xkforge/aws-infrastructure-tf.git//modules/asg?ref=v1.0.0"

  name               = "web-server"
  ami_id             = "ami-0c55b159cbfafe1f0"
  instance_type      = "t3.small"
  security_group_ids = [module.sg.security_group_id]
  subnet_ids         = ["subnet-aaa", "subnet-bbb"]

  min_size         = 2
  max_size         = 6
  desired_capacity = 2

  health_check_type = "ELB"
  target_group_arns = [module.alb.target_group_arn]

  enable_scaling_policy  = true
  target_cpu_utilization = 70

  user_data = <<-EOF
    #!/bin/bash
    echo "Hello from user data"
  EOF

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `name` | Name for the ASG and related resources | `string` | — | yes |
| `ami_id` | AMI ID for the launch template | `string` | — | yes |
| `instance_type` | EC2 instance type | `string` | `"t3.micro"` | no |
| `key_name` | SSH key pair name | `string` | `null` | no |
| `security_group_ids` | Security group IDs for instances | `list(string)` | `[]` | no |
| `subnet_ids` | Subnet IDs for the ASG | `list(string)` | — | yes |
| `min_size` | Minimum number of instances | `number` | `1` | no |
| `max_size` | Maximum number of instances | `number` | `3` | no |
| `desired_capacity` | Desired number of instances | `number` | `1` | no |
| `health_check_type` | Health check type (`EC2`, `ELB`) | `string` | `"EC2"` | no |
| `health_check_grace_period` | Seconds before health checks start | `number` | `300` | no |
| `target_group_arns` | ALB target group ARNs | `list(string)` | `[]` | no |
| `iam_instance_profile_arn` | IAM instance profile ARN | `string` | `null` | no |
| `user_data` | User data script (plain text) | `string` | `null` | no |
| `enable_monitoring` | Enable detailed CloudWatch monitoring | `bool` | `true` | no |
| `enable_scaling_policy` | Enable CPU-based scaling policy | `bool` | `false` | no |
| `target_cpu_utilization` | Target CPU % for scaling (1-100) | `number` | `70` | no |
| `wait_for_capacity_timeout` | Timeout for ASG capacity | `string` | `"10m"` | no |
| `tags` | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `asg_id` | ID of the Auto Scaling Group |
| `asg_arn` | ARN of the Auto Scaling Group |
| `asg_name` | Name of the Auto Scaling Group |
| `launch_template_id` | ID of the launch template |
| `launch_template_latest_version` | Latest version of the launch template |
