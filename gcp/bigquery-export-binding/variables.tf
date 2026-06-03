variable "stitcher_environment_id" {
  type        = string
  description = "The StitcherAI environment id."
}

variable "stitcher_ai_sa_email" {
  type        = string
  description = "The StitcherAI service account email. (Provided by StitcherAI)"
}

variable "customer_gcp_project_id" {
  description = "GCP project id that houses the cost data for Google Cloud services."
  type        = string
}

variable "customer_bigquery_export_dataset_id" {
  description = "Customer bigquery dataset id"
  type        = string
}
