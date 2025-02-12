locals {
  bucket_name = "${var.tenant_prefix}${var.tenant_name}-${random_string.postfix.result}"
}

resource "random_string" "postfix" {
  length  = 8
  special = false
  upper   = false
}

resource "minio_iam_user" "tenant" {
  name          = "${var.tenant_name}-${random_string.postfix.result}"
  force_destroy = true
  tags          = var.tenant_user_tags
}

resource "minio_iam_policy" "access_bucket" {
  policy = jsonencode({
    "Version" : "2012-10-17"
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:*"
        ],
        "Resource" : [
          "arn:aws:s3:::${local.bucket_name}/*",
          "arn:aws:s3:::${local.bucket_name}"
        ]
      },
    ]
  })
}

resource "minio_iam_user_policy_attachment" "name" {
  policy_name = minio_iam_policy.access_bucket.name
  user_name   = minio_iam_user.tenant.name
}

resource "minio_iam_service_account" "name" {
  target_user = minio_iam_user.tenant.name
}

resource "minio_s3_bucket" "tenant" {
  bucket        = local.bucket_name
  force_destroy = var.bucket_force_destroy
}
