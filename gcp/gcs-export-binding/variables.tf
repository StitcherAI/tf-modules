variable "stitcher_environment_id" {
  type        = string
  description = "The StitcherAI environment id."
}

variable "stitcher_ai_sa_email" {
  type        = string
  description = "The StitcherAI service account email. (Provided by StitcherAI)"
}

variable "customer_gcs_bucket" {
  description = "The GCS Bucket to write StitcherAI data into."
  type        = string
}

variable "customer_gcs_path" {
  description = "The Path within the GCS Bucket to write StitcherAI data into."
  type        = string
}

variable "customer_gcs_project_id" {
  description = "The GCP project id that contains gcs-bucket/bigquery-dataset from where cost data will be extracted."
  type        = string
}

variable "customer_gcp_gcs_bucket_list_role_id" {
  description = "The GCP role name to be assigned to the StitcherAI service account, to be able to list objects in gcs."
  type        = string

  default = "StitcherBucketListRole"
}
