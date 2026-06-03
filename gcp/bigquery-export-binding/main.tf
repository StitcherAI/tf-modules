resource "google_bigquery_dataset_iam_member" "bigquery_export_member" {
  project    = var.customer_gcp_project_id
  dataset_id = var.customer_bigquery_export_dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${var.stitcher_ai_sa_email}"
}
