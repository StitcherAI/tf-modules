locals {
  # Check if the s3_path is null or empty, and construct the full path accordingly.
  # Any trailing slash is trimmed first so a path like "cur-reports/hourly/" does not produce a double slash
  # ("cur-reports/hourly//*") that would fail to match the real object keys.
  final_s3_path = var.customer_s3_path != null && var.customer_s3_path != "" ? "${trimsuffix(var.customer_s3_path, "/")}/*" : "*"
}

resource "aws_iam_policy" "stitcher_ai_s3_read_data_policy" {
  description = "IAM policy to grant stitcher access to s3 bucket to be able to read cost/reference datasets"

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
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::${var.customer_s3_bucket}/${local.final_s3_path}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "stitcher_s3_read_data_policy_attachment" {
  role       = var.stitcher_ai_role
  policy_arn = aws_iam_policy.stitcher_ai_s3_read_data_policy.arn
}
