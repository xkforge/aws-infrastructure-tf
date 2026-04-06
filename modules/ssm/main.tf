resource "aws_ssm_parameter" "this" {
  for_each = var.parameters

  name        = each.value.name
  description = lookup(each.value, "description", "Managed by Terraform")
  type        = each.value.type
  value       = each.value.value
  tier        = lookup(each.value, "tier", "Standard")
  key_id      = each.value.type == "SecureString" ? lookup(each.value, "key_id", null) : null

  tags = merge(
    { Name = each.value.name },
    var.tags
  )

  lifecycle {
    ignore_changes = [value]
  }
}
