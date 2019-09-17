output "roles" {
  value = { for k, v in aws_iam_role.service_groups : k => {
    name      = v.name
    unique_id = v.unique_id
    arn       = v.arn
  } }
  description = "A map from service group name (as specified in the service_groups map) to an object representing the IAM role for that service group."
}

output "role_names" {
  value       = { for k, v in aws_iam_role.service_groups : k => v.name }
  description = "A convenience variant of the output \"roles\" whose values are the role names directly."
}

output "role_arns" {
  value       = { for k, v in aws_iam_role.service_groups : k => v.arn }
  description = "A convenience variant of the output \"roles\" whose values are the role arns directly."
}

output "role_unique_ids" {
  value       = { for k, v in aws_iam_role.service_groups : k => v.unique_id }
  description = "A convenience variant of the output \"roles\" whose values are the role unique IDs directly."
}
