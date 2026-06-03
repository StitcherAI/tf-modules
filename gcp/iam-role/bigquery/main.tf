resource "google_project_iam_member" "job_creation_member" {
  project = var.customer_gcp_project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${var.stitcher_ai_sa_email}"
}
