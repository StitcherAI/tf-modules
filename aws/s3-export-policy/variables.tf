variable "s3_bucket" {
  description = "ARN of the s3 bucket to which StitcherAI will export data to"
  type        = string
}

variable "s3_path" {
  description = "Path prefix within the s3 bucket to which StitcherAI will export data to"
  type        = string
  default     = ""
}

variable "stitcher_ai_role" {
  description = "The name of the IAM role to attach this policy to"
  type = string
}
