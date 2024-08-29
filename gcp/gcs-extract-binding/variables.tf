variable "stitcher_ai_sa" {
  description = "The service account email for the Stitcher AI service. (Provided by StitcherAI)"
  type        = string
}

variable "gcs_bucket" {
  description = "The GCS Bucket to write StitcherAI data into."
  type = string
}

variable "gcs_path" {
  description = "The Path within the GCS Bucket to write StitcherAI data into."
  type = string
}
