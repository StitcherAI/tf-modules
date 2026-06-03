variable "customer_s3_bucket" {
  description = "Name of the s3 bucket to which StitcherAI will export data (bucket name only, not an ARN)"
  type        = string
}

variable "customer_s3_path" {
  description = "Key prefix within the s3 bucket to which StitcherAI will export data, e.g. \"stitcher-outputs\". Provide a bare key prefix with no leading slash and no s3:// scheme. Defaults to empty string (whole bucket)."
  type        = string
  default     = ""
}

variable "stitcher_ai_role" {
  description = "The name of the IAM role to attach this policy to"
  type        = string
}
