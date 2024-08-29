variable "stitcher_ai_sa" {
  description = "The service account email for the Stitcher AI service. (Provided by StitcherAI)"
  type        = string
}

variable "gcp_project_id" {
  description = "GCP project id that houses the cost data for Google Cloud services."
  type        = string
}

variable "bigquery_export_dataset_id" {
  description = "Bigquery export dataset id"
  type        = string
}
