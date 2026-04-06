provider "aws" {
  region = "us-east-1"
}

module "ssm" {
  source = "../../modules/ssm"

  parameters = {
    db_host = {
      name        = "/myapp/dev/db_host"
      type        = "String"
      value       = "db.dev.internal"
      description = "Database host address"
    }
    db_port = {
      name        = "/myapp/dev/db_port"
      type        = "String"
      value       = "5432"
      description = "Database port"
    }
    db_password = {
      name        = "/myapp/dev/db_password"
      type        = "SecureString"
      value       = "change-me"
      description = "Database password (update via AWS Console)"
    }
    allowed_origins = {
      name        = "/myapp/dev/allowed_origins"
      type        = "StringList"
      value       = "http://localhost:3000,http://localhost:8080"
      description = "CORS allowed origins"
    }
  }

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

output "parameter_arns" {
  value = module.ssm.parameter_arns
}
