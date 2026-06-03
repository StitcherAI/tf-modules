output "bucket_list_role_id" {
  description = "The full role id of the StitcherAI bucket-list custom role, to be consumed by the gcs extract/export binding modules."
  value       = google_project_iam_custom_role.stitcher_bucket_list_role.role_id
}
