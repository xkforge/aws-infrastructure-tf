# SSM Module

Terraform module for managing AWS Systems Manager Parameter Store parameters. Supports `String`, `StringList`, and `SecureString` parameter types with optional KMS encryption.

## Features

- Bulk parameter creation using a map
- Support for all SSM parameter types
- Optional KMS encryption for `SecureString` parameters
- Configurable parameter tiers (Standard, Advanced, Intelligent-Tiering)
- Ignores external value changes by default

## Usage

```hcl
module "ssm" {
  source = "git::https://github.com/xkforge/aws-infrastructure-tf.git//modules/ssm?ref=v1.0.0"

  parameters = {
    db_host = {
      name  = "/myapp/production/db_host"
      type  = "String"
      value = "db.example.com"
    }
    db_password = {
      name        = "/myapp/production/db_password"
      type        = "SecureString"
      value       = "initial-value"
      description = "Database password"
    }
    allowed_origins = {
      name  = "/myapp/production/allowed_origins"
      type  = "StringList"
      value = "https://example.com,https://api.example.com"
    }
  }

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

> **Note:** The module uses `lifecycle { ignore_changes = [value] }` to prevent Terraform from overwriting values that were updated externally (e.g., via AWS Console or CI/CD pipelines).

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `parameters` | Map of SSM parameters to create | `map(object)` | `{}` | no |
| `tags` | Additional tags to apply to all parameters | `map(string)` | `{}` | no |

### Parameter Object

| Attribute | Type | Required | Description |
|-----------|------|----------|-------------|
| `name` | `string` | yes | Full parameter name (e.g., `/app/env/key`) |
| `type` | `string` | yes | `String`, `StringList`, or `SecureString` |
| `value` | `string` | yes | Parameter value |
| `description` | `string` | no | Parameter description (default: `"Managed by Terraform"`) |
| `tier` | `string` | no | `Standard`, `Advanced`, or `Intelligent-Tiering` (default: `"Standard"`) |
| `key_id` | `string` | no | KMS key ID for `SecureString` encryption |

## Outputs

| Name | Description |
|------|-------------|
| `parameter_arns` | Map of parameter keys to their ARNs |
| `parameter_names` | Map of parameter keys to their full names |
| `parameter_versions` | Map of parameter keys to their version numbers |
