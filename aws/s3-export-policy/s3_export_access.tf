locals {
  # Check if the s3_path is null or empty, and construct the full path accordingly.
  # Any trailing slash is trimmed first so a path like "exports/" does not produce a double slash ("exports//*")
  # that would fail to match the real object keys.
  final_s3_path = var.customer_s3_path != null && var.customer_s3_path != "" ? "${trimsuffix(var.customer_s3_path, "/")}/*" : "*"
}

resource "aws_iam_policy" "stitcher_ai_s3_data_export_policy" {
  description = "IAM policy to grant StitcherAI access to an s3 bucket to be able to export processed data"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": "arn:aws:s3:::${var.customer_s3_bucket}",
      "Condition": {
        "StringLike": {
          "s3:prefix": "${local.final_s3_path}"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::${var.customer_s3_bucket}/${local.final_s3_path}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "stitcher_ai_s3_data_export_policy_attachment" {
  role       = var.stitcher_ai_role
  policy_arn = aws_iam_policy.stitcher_ai_s3_data_export_policy.arn
}
