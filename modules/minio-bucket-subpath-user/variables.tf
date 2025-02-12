variable "user_prefix" {
  description = "Apply this prefix to the user and subdirectory name"
  type        = string
}

variable "user_name" {
  description = "Name of the user that should get a unique path in the bucket. Will be postfixed with a unique id"
  type        = string
}

variable "bucket_name" {
  description = "The bucket that the user should get a subpath in."
  type        = string
}

variable "user_tags" {
  type    = map(string)
  default = {}
}
