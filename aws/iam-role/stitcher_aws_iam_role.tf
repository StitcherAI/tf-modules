resource "aws_iam_role" "stitcher_ai_role" {
  name = var.customer_iam_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.stitcher_aws_iam_principal_arn
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "sts:ExternalId" = var.customer_external_id
          }
        }
      }
    ]
  })
}
