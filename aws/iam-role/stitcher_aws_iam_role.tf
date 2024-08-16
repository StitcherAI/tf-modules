resource "aws_iam_role" "stitcher_ai_role" {
  name = var.iam_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:sts::${var.stitcher_ai_aws_account_id}:assumed-role/stitcher_environment_role_${var.environment_id}/${var.environment_id}"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.external_id
          }
        }
      }
    ]
  })
}
