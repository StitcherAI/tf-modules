# Define an IAM policy resource named "stitcher_ai_cur_describe_policy"
# This policy allows describing the way the Cost and Usage Report (CUR) is configured
resource "aws_iam_policy" "stitcher_ai_cur_describe_policy" {
  description = "Policy for describing the way the CUR report is configured"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": "cur:DescribeReportDefinitions",
        "Resource": "*"
    }
  ]
}
EOF
}

# Attach the previously defined IAM policy to a specified IAM role
resource "aws_iam_role_policy_attachment" "stitcher_cur_describe_policy_attachment" {
  role       = var.stitcher_ai_role  # The IAM role to attach the policy to
  policy_arn = aws_iam_policy.stitcher_ai_cur_describe_policy.arn  # The ARN of the policy to attach
}
