variable "stitcher_environment_id" {
  description = "The StitcherAI environment id. (Provided by StitcherAI)"
  type        = string
}

variable "stitcher_aws_iam_principal_arn" {
  description = "The ARN of the StitcherAI AWS IAM principal that will assume this role. (Provided by StitcherAI)"
  type        = string
}

variable "customer_iam_role_name" {
  description = "The name of the role to create in the customer AWS environment."
  type        = string
}

variable "customer_external_id" {
  description = "External ID to enhance security, as recommended by AWS IAM."
  type        = string
}
