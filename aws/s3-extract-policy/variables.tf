variable "s3_bucket" {
  description = "ARN of the s3 bucket from which StitcherAI will retrieve data (AWS CUR data, generic cost or business data)"
  type        = string
}

variable "s3_path" {
  description = "Path prefix within the s3 bucket from which StitcherAI will retrieve data (AWS CUR data, generic cost or business data). Defaults to empty string"
  type        = string
  default     = ""  
}

variable "stitcher_ai_role" {
  description = "The name of the IAM role to attach this policy to"
  type = string
}
