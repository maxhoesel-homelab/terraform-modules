variable "firewall_filters" {
  description = "Map of firewall rules, where the key is the identifier for the rule"
  type = map(object({
    interfaces  = set(string)
    description = string
    source = object({
      invert = optional(bool, false)
      name   = optional(string, "any")
      alias  = optional(string)
    })
    destination = object({
      invert = optional(bool, false)
      name   = optional(string, "any")
      alias  = optional(string)
      port   = string
    })
    action      = optional(string, "pass")
    ip_protocol = optional(string, "inet")
    protocol    = optional(string, "TCP/UDP")
  }))

  validation {
    condition     = alltrue([for name, filter in var.firewall_filters : filter.source.name != "any" ? filter.source.alias == null : true])
    error_message = "source: name and alias may not be defined at the same time"
  }
  validation {
    condition     = alltrue([for name, filter in var.firewall_filters : filter.destination.name != "any" ? filter.destination.alias == null : true])
    error_message = "destination: name ans alias may not be defined at the same time"
  }
}

variable "firewall_prefix" {
  description = "Optionally set a prefix that is applied to all aliases"
  type        = string
  default     = ""
  validation {
    condition     = can(regex("(^[a-z_]+[\\w]*$|^$)", var.firewall_prefix))
    error_message = "Prefix must be alphanumeric and start with a letter or underscore"
  }
}

variable "firewall_host_aliases" {
  type = map(object({
    hosts       = set(string)
    description = optional(string)
  }))
  validation {
    # max length: 32 - 7 from local.postfix_length (6 + _) - (len(prefix) + 1 (_))
    condition     = alltrue([for name, _ in var.firewall_host_aliases : var.firewall_prefix != "" ? length(name) < 32 - local.postfix_length - 1 - length(var.firewall_prefix) - 1 : length(name) < 32 - local.postfix_length - 1])
    error_message = "Alias name must be less than ${var.firewall_prefix != "" ? 32 - local.postfix_length - 1 - length(var.firewall_prefix) - 1 : 32 - local.postfix_length - 1} characters (32 including prefix and local.postfix_length)"
  }
  validation {
    condition     = alltrue([for name, _ in var.firewall_host_aliases : var.firewall_prefix != "" ? can(regex("^[\\w]+$", name)) : can(regex("^[a-z_]+[\\w]*$", name))])
    error_message = "Alias name must be alphanumeric and start with a letter or underscore"
  }
}

# Currently not available in the provider or the OPNsense API
# Opnsense does have SNAT, but we need PF/DNAT
#variable "firewall_nat" {
#  type = map(object({
#    description = string
#    protocol    = optional(string, "TCP/UDP")
#    nat_port    = string
#    target      = string
#    target_port = string
#  }))
#}

#variable "firewall_wan_interface" {
#  type = string
#}
