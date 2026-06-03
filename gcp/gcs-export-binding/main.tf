resource "google_storage_bucket_iam_member" "export_role_member" {
  bucket = var.customer_gcs_bucket
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${var.stitcher_ai_sa_email}"

  condition {
    expression = "resource.name.startsWith(\"projects/_/buckets/${var.customer_gcs_bucket}/objects/${var.customer_gcs_path}\")"
    title      = "${var.stitcher_ai_sa_email} restricts access to base_path for data export role"
  }
}

data "google_project_iam_custom_role" "stitcher_bucket_list_role" {
  role_id = var.customer_gcp_gcs_bucket_list_role_id

  project = var.customer_gcs_project_id
}

resource "google_storage_bucket_iam_member" "export_role_list_member" {
  bucket = var.customer_gcs_bucket
  role   = data.google_project_iam_custom_role.stitcher_bucket_list_role.id
  member = "serviceAccount:${var.stitcher_ai_sa_email}"
}
