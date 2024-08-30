variable "stitcher_environment_id" {
  type        = string
  description = "The StitcherAI environment id."
}

variable "gcp_domain" {
  description = "(Optional) The gcp domain for the Stitcher AI service."
  type        = string
  default     = null
}

variable "gcp_project_id" {
  description = "GCP project id that houses the cost data for Google Cloud services."
  type        = string
}

variable "bigquery_export_dataset_id" {
  description = "Bigquery export dataset id"
  type        = string
}
