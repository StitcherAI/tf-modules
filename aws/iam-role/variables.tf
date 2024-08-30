variable "iam_role_name" {
  description = "The name of the role to create in the customer AWS environment."
  type        = string
}

variable "external_id" {
  description = "External ID to enhance security, as recommended by AWS IAM."
  type        = string
}

variable "stitcher_ai_aws_account_id" {
  description = "The StitcherAI AWS account id. (Provided by StitcherAI)"
  type        = string
}

variable "environment_id" {
  description = "The StitcherAI environment id. (Provided by StitcherAI)"
  type        = string
}
