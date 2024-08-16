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
      "Resource": "arn:aws:s3:::${var.s3_bucket}",
      "Condition": {
        "StringLike": {
          "s3:prefix": "${var.s3_path}/*"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::${var.s3_bucket}/${var.s3_path}/*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "stitcher_s3_read_data_policy_attachment" {
  role       = var.stitcher_ai_role
  policy_arn = aws_iam_policy.stitcher_ai_s3_read_data_policy.arn
}
