variable "app_name" {
  description = "Name of the Authentik Application and Provider"
  validation {
    condition     = can(regex("[A-Za-z][a-Za-z0-9-]*", var.app_name))
    error_message = "App name must consist out of letters, digits and dashes and start with a letter"
  }
}

variable "client_type" {
  description = "Whether the client can keep the secret safe (confidential) or not (public)"
  default     = "confidential"
}

variable "authorization_flow" {
  description = "Authorization flow to use for the provider"
  default     = "default-provider-authorization-explicit-consent"
}
variable "invalidation_flow" {
  description = "Invalidation flow to use for the provider"
  default     = "default-provider-invalidation-flow"
}

variable "allowed_redirect_urls" {
  description = "Redirect URLs for the Oauth2 provider"
  type = list(object({
    url           = string
    matching_mode = optional(string, "strict")
  }))
  default = []
}

variable "custom_scopes" {
  description = "Custom scope property mappings to add for the provider"
  type = list(object({
    name       = string
    expression = string
  }))
  default = []
}

variable "scopes" {
  description = "List of property mapping/scopes to enable for the provider. Custom scopes will be added automatically"
  type        = list(string)
  default     = ["openid", "profile", "email"]
}

variable "subject_mode" {
  description = "How to generate the subject id for the auth token"
  default     = null
}

variable "group_bindings" {
  description = "Groups to bind to the oauth provider"
  type = list(object({
    name  = string
    order = optional(number, 0)
  }))
}

variable "output_config_template" {
  description = "Template that will be rendered to outputs.config to directly generate application configs. Available variables are $app_name (no suffix), $client_id, $client_secret and $configuration_url"
  type        = string
  default     = "{\"client_id\": \"$client_id\", \"client_secret\": \"$client_secret\", \"url\": \"$configuration_url\"}"
}
