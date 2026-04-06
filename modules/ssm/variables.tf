variable "parameters" {
  description = "Map of SSM parameters to create. Each entry defines a parameter with its name, type, value, and optional settings"
  type = map(object({
    name        = string
    type        = string
    value       = string
    description = optional(string, "Managed by Terraform")
    tier        = optional(string, "Standard")
    key_id      = optional(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.parameters : contains(["String", "StringList", "SecureString"], v.type)
    ])
    error_message = "Parameter type must be one of: String, StringList, SecureString."
  }

  validation {
    condition = alltrue([
      for k, v in var.parameters : contains(["Standard", "Advanced", "Intelligent-Tiering"], v.tier)
    ])
    error_message = "Parameter tier must be one of: Standard, Advanced, Intelligent-Tiering."
  }
}

variable "tags" {
  description = "Additional tags to apply to all SSM parameters"
  type        = map(string)
  default     = {}
}
