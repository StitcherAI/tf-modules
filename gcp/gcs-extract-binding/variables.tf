variable "stitcher_environment_id" {
  type        = string
  description = "The StitcherAI environment id."
}

variable "gcp_domain" {
  description = "(Optional) The gcp domain for the Stitcher AI service."
  type        = string
  default     = null
}

variable "gcs_bucket" {
  description = "The GCS Bucket to write StitcherAI data into."
  type        = string
}

variable "gcs_path" {
  description = "The Path within the GCS Bucket to write StitcherAI data into."
  type        = string
}
