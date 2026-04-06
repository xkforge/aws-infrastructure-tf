variable "name" {
  description = "Name for the Auto Scaling Group and related resources"
  type        = string

  nullable = false
}

variable "ami_id" {
  description = "AMI ID for the launch template"
  type        = string

  nullable = false
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair for instance access"
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "List of security group IDs for the instances"
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Auto Scaling Group"
  type        = list(string)

  nullable = false
}

variable "min_size" {
  description = "Minimum number of instances in the ASG"
  type        = number
  default     = 1

  validation {
    condition     = var.min_size >= 0
    error_message = "min_size must be a non-negative number."
  }
}

variable "max_size" {
  description = "Maximum number of instances in the ASG"
  type        = number
  default     = 3

  validation {
    condition     = var.max_size >= 1
    error_message = "max_size must be at least 1."
  }
}

variable "desired_capacity" {
  description = "Desired number of instances in the ASG"
  type        = number
  default     = 1

  validation {
    condition     = var.desired_capacity >= 0
    error_message = "desired_capacity must be a non-negative number."
  }
}

variable "health_check_type" {
  description = "Health check type for the ASG. Valid values: EC2, ELB"
  type        = string
  default     = "EC2"

  validation {
    condition     = contains(["EC2", "ELB"], var.health_check_type)
    error_message = "health_check_type must be either EC2 or ELB."
  }
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance launch before health checks start"
  type        = number
  default     = 300
}

variable "target_group_arns" {
  description = "List of ALB target group ARNs to attach to the ASG"
  type        = list(string)
  default     = []
}

variable "iam_instance_profile_arn" {
  description = "ARN of the IAM instance profile for the launch template"
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data script for the launch template (plain text, will be base64 encoded)"
  type        = string
  default     = null
}

variable "enable_monitoring" {
  description = "Enable detailed CloudWatch monitoring for instances"
  type        = bool
  default     = true
}

variable "enable_scaling_policy" {
  description = "Enable CPU-based target tracking scaling policy"
  type        = bool
  default     = false
}

variable "target_cpu_utilization" {
  description = "Target CPU utilization percentage for the scaling policy"
  type        = number
  default     = 70

  validation {
    condition     = var.target_cpu_utilization > 0 && var.target_cpu_utilization <= 100
    error_message = "target_cpu_utilization must be between 1 and 100."
  }
}

variable "wait_for_capacity_timeout" {
  description = "Maximum duration to wait for ASG instances to become healthy"
  type        = string
  default     = "10m"
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
