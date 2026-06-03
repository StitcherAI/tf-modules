variable "customer_gcp_project_id" {
  description = "The GCP project id that contains gcs-bucket/bigquery-dataset from where cost data will be extracted."
  type        = string
}

variable "customer_gcp_gcs_bucket_list_role_id" {
  description = "The GCP role name to be assigned to the StitcherAI service account, to be able to list objects in gcs."
  type        = string

  default = "StitcherBucketListRole"
}
