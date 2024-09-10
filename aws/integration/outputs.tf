output "export_bucket" {
  value = {
    name = local.export_s3_bucket
    path = var.export_s3_path
  }
}

output "role" {
  value = {
    arn         = aws_iam_role.integration.arn
    external_id = local.external_id
    name        = aws_iam_role.integration.name
  }
}

output "stitcher_ai" {
  value = {
    aws_account_id = var.stitcher_ai_aws_account_id
    environment_id = var.environment_id
  }
}
