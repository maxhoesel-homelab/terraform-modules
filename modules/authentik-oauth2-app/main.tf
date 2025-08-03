locals {
  property_mappings = concat(
    [for s in data.authentik_property_mapping_provider_scope.scopes : s.id],
    [for s in authentik_property_mapping_provider_scope.custom_scopes : s.id]
  )
}

data "authentik_property_mapping_provider_scope" "scopes" {
  for_each   = { for scope in var.scopes : scope => {} }
  scope_name = each.key
}
data "authentik_group" "bindings" {
  for_each = { for group in var.group_bindings : group.name => group }
  name     = each.key
}
data "authentik_flow" "authorization_flow" {
  slug = var.authorization_flow
}
data "authentik_flow" "invalidation_flow" {
  slug = var.invalidation_flow
}
data "authentik_certificate_key_pair" "name" {
  name              = "authentik Self-signed Certificate"
  fetch_certificate = false
  fetch_key         = false
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "authentik_application" "app" {
  name              = var.app_name
  slug              = "${lower(var.app_name)}-${random_string.suffix.result}"
  protocol_provider = authentik_provider_oauth2.app.id
}

resource "random_string" "client_id" {
  length  = 40
  special = false
}
resource "authentik_provider_oauth2" "app" {
  name      = "${lower(var.app_name)}-${random_string.suffix.result}"
  client_id = random_string.client_id.result

  allowed_redirect_uris = var.allowed_redirect_urls
  authorization_flow    = data.authentik_flow.authorization_flow.id
  invalidation_flow     = data.authentik_flow.invalidation_flow.id
  client_type           = var.client_type
  property_mappings     = local.property_mappings
  sub_mode              = var.subject_mode
  signing_key           = data.authentik_certificate_key_pair.name.id
}

resource "authentik_property_mapping_provider_scope" "custom_scopes" {
  for_each = { for scope in var.custom_scopes : scope.name => scope }

  name       = "${each.key}-${random_string.suffix.result}"
  expression = each.value.expression
  scope_name = each.key
}

resource "authentik_policy_binding" "groups" {
  for_each = { for group in var.group_bindings : group.name => group }

  order  = each.value.order
  group  = data.authentik_group.bindings[each.key].id
  target = authentik_application.app.uuid
}
