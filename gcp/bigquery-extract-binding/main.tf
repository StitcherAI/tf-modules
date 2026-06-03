resource "google_bigquery_dataset_iam_member" "bigquery_extract_member" {
  project    = var.customer_gcp_project_id
  dataset_id = var.customer_bigquery_cost_dataset_id
  role       = "roles/bigquery.dataViewer"
  member     = "serviceAccount:${var.stitcher_ai_sa_email}"
}

resource "google_project_iam_member" "job_creation_member" {
  project = var.customer_gcp_project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${var.stitcher_ai_sa_email}"
}
