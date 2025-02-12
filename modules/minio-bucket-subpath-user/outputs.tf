output "bucket_name" {
  value       = var.bucket_name
  description = "The name of the bucket that was created"
}
output "bucket_s3_url" {
  value       = "s3://${var.bucket_name}"
  description = "S3-formatted url (s3://) of the created bucket"
}

output "bucket_subdir_s3_url" {
  value       = "s3://${var.bucket_name}/${local.user_id}"
  description = "S3-formatted url including the subpath"
}
output "bucket_subpath" {
  value       = local.user_id
  description = "Name of the subpath that the user has access to"
}

output "access_key_id" {
  value       = minio_iam_service_account.name.access_key
  sensitive   = true
  description = "Access key to login to minio with"
}
output "secret_access_key" {
  value       = minio_iam_service_account.name.secret_key
  sensitive   = true
  description = "Secret key belonging to the access key"
}
output "user" {
  value       = minio_iam_user.tenant.name
  description = "The name of the user created in minio that owns the access key"
}
output "credentials_file" {
  value       = <<EOF
[default]
aws_access_key_id=${minio_iam_service_account.name.access_key}
aws_secret_access_key=${minio_iam_service_account.name.secret_key}
EOF
  description = "aws-config style file containing the credentials under the default profile"
  sensitive   = true
}
