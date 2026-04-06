# Security Group Module

Terraform module for creating an AWS Security Group with flexible ingress and egress rules. Rules are managed as separate resources using `for_each` for stable addressing.

## Usage

```hcl
module "web_sg" {
  source = "git::https://github.com/xkforge/aws-infrastructure-tf.git//modules/security-group?ref=v1.0.0"

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
    }
  ]

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `name` | Name of the security group | `string` | — | yes |
| `description` | Description of the security group | `string` | `"Managed by Terraform"` | no |
| `vpc_id` | ID of the VPC | `string` | — | yes |
| `ingress_rules` | List of ingress rule objects | `list(object)` | `[]` | no |
| `egress_rules` | List of egress rule objects | `list(object)` | Allow all outbound | no |
| `tags` | Additional tags to apply | `map(string)` | `{}` | no |

### Rule Object

| Attribute | Type | Required | Description |
|-----------|------|----------|-------------|
| `from_port` | `number` | yes | Start port |
| `to_port` | `number` | yes | End port |
| `protocol` | `string` | yes | Protocol (`tcp`, `udp`, `icmp`, `-1` for all) |
| `description` | `string` | yes | Rule description (used as map key) |
| `cidr_blocks` | `list(string)` | no | IPv4 CIDR blocks |
| `ipv6_cidr_blocks` | `list(string)` | no | IPv6 CIDR blocks |
| `source_security_group_id` | `string` | no | Source security group ID |

## Outputs

| Name | Description |
|------|-------------|
| `security_group_id` | ID of the security group |
| `security_group_arn` | ARN of the security group |
| `security_group_name` | Name of the security group |
