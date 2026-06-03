resource "google_project_iam_custom_role" "stitcher_bucket_list_role" {
  role_id     = var.customer_gcp_gcs_bucket_list_role_id
  title       = "Bucket list role for StitcherAI"
  description = "Allows listing buckets for GCS based extract/integrate"

  project = var.customer_gcp_project_id

  permissions = [
    "storage.folders.list",
    "storage.objects.list",
  ]
}
