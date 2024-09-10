variable "iam_role_name" {
  description = "The name of the role to create in the customer AWS environment."
  type        = string
  default     = "StitcherAI-Integration"
}

variable "external_id" {
  description = "External ID to enhance security, as recommended by AWS IAM.  Will be generated if not provided."
  type        = string
  default     = null
}

variable "stitcher_ai_aws_account_id" {
  description = "The StitcherAI AWS account id. (Provided by StitcherAI)"
  type        = string
}

variable "environment_id" {
  description = "The StitcherAI environment id. (Provided by StitcherAI)"
  type        = string
}

variable "s3_buckets" {
  description = "List of s3 buckets from which StitcherAI will retrieve data (AWS CUR data, generic cost or business data)"
  type = list(object({
    name = string
    path = optional(string, "")
  }))
}

variable "export_s3_bucket" {
  description = "Name of the s3 bucket to which StitcherAI will export data to.  Leave null to auto-create bucket."
  type        = string
  default     = null
}

variable "export_s3_bucket_tags" {
  description = "Tags to apply to the export s3 bucket (only if export_s3_bucket is null)"
  type        = map(string)
  default     = {}
}

variable "export_s3_path" {
  description = "Path prefix within the s3 bucket to which StitcherAI will export data to"
  type        = string
  default     = ""
}
