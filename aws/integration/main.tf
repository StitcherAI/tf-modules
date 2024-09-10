locals {
  external_id      = var.external_id == null ? random_string.external_id[0].result : var.external_id
  export_s3_bucket = var.export_s3_bucket == null ? module.export_bucket[0].bucket_name : var.export_s3_bucket
}

resource "random_string" "external_id" {
  count = var.external_id == null ? 1 : 0

  length           = 32
  override_special = "+=,.@:/-"
}

resource "aws_iam_role" "integration" {
  name               = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.arpd.json

  inline_policy {
    name   = "cur_describe_policy"
    policy = data.aws_iam_policy_document.cur_describe_policy.json
  }

  inline_policy {
    name   = "s3_read_data_policy"
    policy = data.aws_iam_policy_document.s3_read_data_policy.json
  }

  inline_policy {
    name   = "s3_export_policy"
    policy = data.aws_iam_policy_document.s3_export_policy.json
  }
}

data "aws_iam_policy_document" "arpd" {
  version = "2012-10-17"
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:sts::${var.stitcher_ai_aws_account_id}:assumed-role/stitcher_environment_role_${var.environment_id}/${var.environment_id}"]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [local.external_id]
    }
  }
}

# This policy allows describing the way the Cost and Usage Report (CUR) is configured
data "aws_iam_policy_document" "cur_describe_policy" {
  version = "2012-10-17"
  statement {
    actions = [
      "cur:DescribeReportDefinitions"
    ]
    resources = ["*"]
  }
}

# IAM policy to grant stitcher access to s3 buckets to be able to read cost/reference datasets
data "aws_iam_policy_document" "s3_read_data_policy" {
  version = "2012-10-17"
  dynamic "statement" {
    for_each = var.s3_buckets
    content {
      actions = [
        "s3:ListBucket"
      ]
      resources = [
        "arn:aws:s3:::${statement.value.name}"
      ]
      condition {
        test     = "StringLike"
        variable = "s3:prefix"
        values   = ["${statement.value.path}/*"]
      }
    }
  }
  dynamic "statement" {
    for_each = var.s3_buckets
    content {
      actions = [
        "s3:GetObject"
      ]
      resources = [
        "arn:aws:s3:::${statement.value.name}/${statement.value.path}/*"
      ]
    }
  }
}

# IAM policy to grant StitcherAI access to an s3 bucket to be able to export processed data
data "aws_iam_policy_document" "s3_export_policy" {
  version = "2012-10-17"
  statement {
    actions = [
      "s3:ListBucket",
    ]
    resources = [
      "arn:aws:s3:::${local.export_s3_bucket}",
    ]
    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["${var.export_s3_path}/*"]
    }
  }
  statement {
    actions = [
      "s3:DeleteObject",
      "s3:ListObjectsV2",
      "s3:PutObject",
    ]
    resources = [
      "arn:aws:s3:::${local.export_s3_bucket}/${var.export_s3_path}/*",
    ]
  }
}
