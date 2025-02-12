locals {
  user_id = "${var.user_prefix}${var.user_name}-${random_string.postfix.result}"
}

resource "random_string" "postfix" {
  length  = 8
  special = false
  upper   = false
}

resource "minio_iam_user" "tenant" {
  name          = local.user_id
  force_destroy = true
  tags          = var.user_tags
}

resource "minio_iam_policy" "access_bucket" {
  policy = jsonencode({
    "Version" : "2012-10-17"
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject*",
          "s3:PutObject*",
          "s3:ListBucket",
          "s3:DeleteObject*"
        ],
        "Resource" : [
          "arn:aws:s3:::${local.bucket_name}${local.user_id}/*",
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : "s3:ListBucket",
        "Resource" : "arn:aws:s3:::${var.bucket_name}",
        "Condition" : {
          "StringLike" : {
            "s3:prefix" : "${local.user_id}/*"
          }
        }
      }
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
