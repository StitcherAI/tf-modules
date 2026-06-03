variable "customer_s3_bucket" {
  description = "Name of the s3 bucket from which StitcherAI will retrieve data (bucket name only, not an ARN) (AWS CUR data, generic cost or business data)"
  type        = string
}

variable "customer_s3_path" {
  description = "Key prefix within the s3 bucket from which StitcherAI will retrieve data, e.g. \"cur-reports/hourly\". Provide a bare key prefix with no leading slash and no s3:// scheme. Defaults to empty string (whole bucket)."
  type        = string
  default     = ""
}

variable "stitcher_ai_role" {
  description = "The name of the IAM role to attach this policy to"
  type        = string
}
