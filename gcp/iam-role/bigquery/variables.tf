variable "customer_gcp_project_id" {
  description = "The GCP project id that contains gcs-bucket/bigquery-dataset from where cost data will be extracted."
  type        = string
}

variable "stitcher_ai_sa_email" {
  type        = string
  description = "The StitcherAI service account email. (Provided by StitcherAI)"
}
