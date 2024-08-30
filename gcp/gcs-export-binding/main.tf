locals {
  # gcp has string length limitation, need to find a method to shorten this string
  uuid_transformed = substr(replace(var.stitcher_environment_id, "-", ""), 0, 24)
  stitcher_ai_sa   = "env-${local.uuid_transformed}@${var.gcp_domain == null ? "stitcher-production" : var.gcp_domain}.iam.gserviceaccount.com"
}

resource "google_storage_bucket_iam_binding" "export_role_binding" {
  bucket  = var.gcs_bucket
  role    = "roles/storage.objectAdmin"
  members = ["serviceAccount:${local.stitcher_ai_sa}"]

  condition {
    expression = "resource.name.startsWith(\"projects/_/buckets/${var.gcs_bucket}/objects/${var.gcs_path}\")"
    title      = "${local.stitcher_ai_sa} restricts access to base_path for data export role"
  }
}
