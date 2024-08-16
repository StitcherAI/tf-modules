resource "aws_iam_policy" "stitcher_ai_s3_data_export_policy" {
  description = "IAM policy to grant StitcherAI access to an s3 bucket to be able to export processed data"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:ListObjectsV2",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::${var.s3_bucket}/${var.s3_path}/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": "arn:aws:s3:::${var.s3_bucket}",
      "Condition": {
        "StringLike": {
          "s3:prefix": "${var.s3_path}/*"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "stitcher_ai_s3_data_export_policy_attachment" {
  role       = var.stitcher_ai_role
  policy_arn = aws_iam_policy.stitcher_ai_s3_data_export_policy.arn
}
