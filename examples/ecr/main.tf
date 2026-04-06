provider "aws" {
  region = "us-east-1"
}

module "ecr" {
  source = "../../modules/ecr"

  name                 = "my-application"
  image_tag_mutability = "IMMUTABLE"
  scan_on_push         = true
  max_image_count      = 30

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

output "repository_url" {
  value = module.ecr.repository_url
}
