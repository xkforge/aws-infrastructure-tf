output "parameter_arns" {
  description = "Map of parameter keys to their ARNs"
  value       = { for k, v in aws_ssm_parameter.this : k => v.arn }
}

output "parameter_names" {
  description = "Map of parameter keys to their full names"
  value       = { for k, v in aws_ssm_parameter.this : k => v.name }
}

output "parameter_versions" {
  description = "Map of parameter keys to their version numbers"
  value       = { for k, v in aws_ssm_parameter.this : k => v.version }
}
