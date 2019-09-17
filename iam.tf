resource "aws_iam_role" "service_groups" {
  for_each = var.service_groups

  name_prefix          = "${var.role_name_prefix}${each.key}"
  path                 = var.role_path
  max_session_duration = var.role_max_session_duration
  tags = merge(
    var.tags,
    var.service_group_tag_key != null ? { "${var.service_group_tag_key}" : each.key } : {},
  )

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : {
      "Effect" : "Allow",
      "Principal" : {
        "Service" : sort(each.value),
      },
      "Action" : "sts:AssumeRole",
    },
  })
}
