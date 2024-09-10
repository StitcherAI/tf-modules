resource "aws_s3_bucket" "export" {
  bucket_prefix = "stitcherai-export"
  tags          = var.tags
}

resource "aws_s3_bucket_ownership_controls" "export" {
  bucket = aws_s3_bucket.export.bucket
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "export" {
  bucket                  = aws_s3_bucket.export.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
