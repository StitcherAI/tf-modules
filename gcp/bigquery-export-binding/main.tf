locals {
  # gcp has string length limitation, need to find a method to shorten this string
  uuid_transformed = substr(replace(var.stitcher_environment_id, "-", ""), 0, 24)
  stitcher_ai_sa   = "env-${local.uuid_transformed}@${var.gcp_domain == null ? "stitcher-production" : var.gcp_domain}.iam.gserviceaccount.com"
}

resource "google_bigquery_dataset_iam_member" "bigquery_export_member" {
  project    = var.gcp_project_id
  dataset_id = var.bigquery_export_dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${local.stitcher_ai_sa}"
}

resource "google_project_iam_member" "job_creation_member" {
  project = var.gcp_project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${local.stitcher_ai_sa}"
}
