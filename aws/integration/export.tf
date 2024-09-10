module "export_bucket" {
  count  = var.export_s3_bucket == null ? 1 : 0
  source = "./export_bucket"

  tags = var.export_s3_bucket_tags
}
