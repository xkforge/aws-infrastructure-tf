variable "name" {
  description = "Name of the Application Load Balancer"
  type        = string

  nullable = false
}

variable "internal" {
  description = "Whether the ALB is internal (true) or internet-facing (false)"
  type        = bool
  default     = false
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the ALB"
  type        = list(string)

  nullable = false
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ALB. Must span at least two availability zones"
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "At least two subnet IDs are required for an ALB."
  }

  nullable = false
}

variable "vpc_id" {
  description = "ID of the VPC for the target group"
  type        = string

  nullable = false
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the ALB"
  type        = bool
  default     = false
}

variable "enable_access_logs" {
  description = "Enable access logging to an S3 bucket"
  type        = bool
  default     = false
}

variable "access_logs_bucket" {
  description = "S3 bucket name for ALB access logs. Required when enable_access_logs is true"
  type        = string
  default     = null
}

variable "access_logs_prefix" {
  description = "S3 key prefix for ALB access logs"
  type        = string
  default     = ""
}

variable "target_group_port" {
  description = "Port on which the target group receives traffic"
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "Protocol for the target group. Valid values: HTTP, HTTPS"
  type        = string
  default     = "HTTP"

  validation {
    condition     = contains(["HTTP", "HTTPS"], var.target_group_protocol)
    error_message = "target_group_protocol must be either HTTP or HTTPS."
  }
}

variable "target_type" {
  description = "Type of target for the target group. Valid values: instance, ip, lambda, alb"
  type        = string
  default     = "instance"

  validation {
    condition     = contains(["instance", "ip", "lambda", "alb"], var.target_type)
    error_message = "target_type must be one of: instance, ip, lambda, alb."
  }
}

variable "health_check" {
  description = "Health check configuration for the target group"
  type = object({
    healthy_threshold   = optional(number, 3)
    unhealthy_threshold = optional(number, 3)
    timeout             = optional(number, 5)
    interval            = optional(number, 30)
    path                = optional(string, "/")
    port                = optional(string, "traffic-port")
    protocol            = optional(string, "HTTP")
    matcher             = optional(string, "200")
  })
  default = {}
}

variable "listener_port" {
  description = "Port for the HTTP listener"
  type        = number
  default     = 80
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS. When set, HTTP traffic is redirected to HTTPS"
  type        = string
  default     = null
}

variable "ssl_policy" {
  description = "SSL policy for the HTTPS listener"
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "tags" {
  description = "Additional tags to apply to ALB resources"
  type        = map(string)
  default     = {}
}
