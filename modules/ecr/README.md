# ECR Module

Terraform module for creating and managing an AWS Elastic Container Registry (ECR) repository with configurable image scanning, encryption, and lifecycle policies.

## Usage

```hcl
module "ecr" {
  source = "git::https://github.com/xkforge/aws-infrastructure-tf.git//modules/ecr?ref=v1.0.0"

  name                 = "my-application"
  image_tag_mutability = "IMMUTABLE"
  scan_on_push         = true
  max_image_count      = 30

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `name` | Name of the ECR repository | `string` | — | yes |
| `image_tag_mutability` | Tag mutability setting (`MUTABLE` or `IMMUTABLE`) | `string` | `"IMMUTABLE"` | no |
| `scan_on_push` | Enable image scanning on push | `bool` | `true` | no |
| `encryption_type` | Encryption type (`AES256` or `KMS`) | `string` | `"AES256"` | no |
| `kms_key_arn` | ARN of the KMS key (required when `encryption_type` is `KMS`) | `string` | `null` | no |
| `max_image_count` | Maximum number of images to retain (set to `null` to disable) | `number` | `null` | no |
| `force_delete` | Delete repository even if it contains images | `bool` | `false` | no |
| `tags` | Additional tags to apply | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `repository_url` | URL of the ECR repository |
| `repository_arn` | ARN of the ECR repository |
| `repository_name` | Name of the ECR repository |
| `registry_id` | Registry ID where the repository was created |
