variable "tenant_prefix" {
  description = "Optionally set a prefix for the tenants bucket, such as 'mycluster-'"
  type        = string
  default     = ""
}
variable "tenant_name" {
  description = "Name of the tenant. This will be the name of the user and the base name of the bucket"
  type        = string
}

variable "bucket_force_destroy" {
  description = "Enable forceful destruction of the bucket on deletion"
  type        = bool
  default     = false
}

variable "tenant_user_tags" {
  description = "Tags to apply to the tenants user"
  type        = map(string)
  default     = {}
}
