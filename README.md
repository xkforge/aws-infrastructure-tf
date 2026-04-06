# AWS Infrastructure Terraform Modules

Reusable Terraform modules for provisioning AWS infrastructure resources. This monorepo contains production-ready modules following [terraform-best-practices.com](https://www.terraform-best-practices.com/) guidelines.

## Available Modules

| Module | Description | Documentation |
|--------|-------------|---------------|
| [ecr](./modules/ecr/) | Elastic Container Registry with lifecycle policies and encryption | [README](./modules/ecr/README.md) |
| [asg](./modules/asg/) | Auto Scaling Group with launch template and scaling policies | [README](./modules/asg/README.md) |
| [alb](./modules/alb/) | Application Load Balancer with target groups and listeners | [README](./modules/alb/README.md) |
| [security-group](./modules/security-group/) | Security Group with flexible ingress/egress rules | [README](./modules/security-group/README.md) |
| [ssm](./modules/ssm/) | SSM Parameter Store for managing configuration parameters | [README](./modules/ssm/README.md) |

## Requirements

| Name | Version |
|------|---------|
| [Terraform](https://www.terraform.io/) | >= 1.9 |
| [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest) | >= 5.0 |

## Usage

```hcl
module "ecr" {
  source = "git::https://github.com/xkforge/aws-infrastructure-tf.git//modules/ecr?ref=v1.0.0"

  name         = "my-app"
  scan_on_push = true

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

> **Tip:** Pin the module source to a specific version tag (`?ref=vX.Y.Z`) for stability.

## Repository Structure

```
.
├── .github/workflows/     # CI/CD pipelines
│   ├── terraform-ci.yml   # Validation, linting, and security scanning
│   └── release.yml        # Automated releases with release-please
├── modules/               # Reusable Terraform modules
│   ├── ecr/
│   ├── asg/
│   ├── alb/
│   ├── security-group/
│   └── ssm/
├── examples/              # Usage examples for each module
│   ├── ecr/
│   ├── asg/
│   ├── alb/
│   ├── security-group/
│   └── ssm/
├── release-please-config.json
├── .release-please-manifest.json
├── CHANGELOG.md
└── LICENSE
```

## CI/CD

### Continuous Integration

Every push and pull request triggers:

1. **Validate** — `terraform fmt` check + `terraform validate` on all modules
2. **Lint** — TFLint analysis across all modules
3. **Security** — Trivy and Checkov scans for misconfigurations

### Automatic Releases

This repository uses [release-please](https://github.com/googleapis/release-please) for automated versioning and releases based on [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

| Commit Prefix | Version Bump | Example |
|---------------|-------------|---------|
| `fix:` | Patch (`0.0.X`) | `fix: correct ALB health check path` |
| `feat:` | Minor (`0.X.0`) | `feat: add WAF integration to ALB module` |
| `feat!:` or `BREAKING CHANGE:` | Major (`X.0.0`) | `feat!: rename security group variables` |

#### How it works

1. Push commits following conventional commit format to `main`
2. Release-please automatically creates a **Release PR** with updated CHANGELOG
3. Merge the Release PR to create a **GitHub Release** with a semantic version tag

## Contributing

1. Create a feature branch from `main`
2. Follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) for commit messages
3. Run `terraform fmt -recursive` before committing
4. Open a Pull Request against `main`

## Pre-commit Hooks

This repository supports [pre-commit](https://pre-commit.com/) for local validation:

```bash
pip install pre-commit
pre-commit install
pre-commit run --all-files
```

## License

This project is licensed under the MIT License. See [LICENSE](./LICENSE) for details.
