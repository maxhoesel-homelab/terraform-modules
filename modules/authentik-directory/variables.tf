variable "groups" {
  description = "Groups to be added to authentik"
  type = list(object({
    name         = string
    attributes   = optional(string)
    is_superuser = optional(bool)
  }))
}

variable "users" {
  description = "Users to be added to authentik. Groups must be defined in var.groups"
  type = list(object({
    uid        = string
    name       = string
    email      = string
    attributes = optional(string)
    groups     = optional(list(string), [])
    password   = optional(string)
  }))
}
