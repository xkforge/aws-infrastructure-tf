variable "name" {
  description = "Name of the ECR repository"
  type        = string

  nullable = false
}

variable "image_tag_mutability" {
  description = "Tag mutability setting for the repository. Valid values: MUTABLE or IMMUTABLE"
  type        = string
  default     = "IMMUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be either MUTABLE or IMMUTABLE."
  }
}

variable "scan_on_push" {
  description = "Enable image scanning on push"
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "Encryption type for the repository. Valid values: AES256 or KMS"
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "encryption_type must be either AES256 or KMS."
  }
}

variable "kms_key_arn" {
  description = "ARN of the KMS key for encryption. Required when encryption_type is KMS"
  type        = string
  default     = null
}

variable "max_image_count" {
  description = "Maximum number of images to keep in the repository. Set to null to disable lifecycle policy"
  type        = number
  default     = null

  validation {
    condition     = var.max_image_count == null || var.max_image_count > 0
    error_message = "max_image_count must be a positive number or null."
  }
}

variable "force_delete" {
  description = "If true, the repository will be deleted even if it contains images"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags to apply to the ECR repository"
  type        = map(string)
  default     = {}
}
