resource "authentik_group" "groups" {
  for_each = { for g in var.groups : g.name => g }

  name         = each.key
  is_superuser = each.value.is_superuser
  attributes   = each.value.attributes
}

resource "authentik_user" "users" {
  for_each = { for u in var.users : u.uid => u }

  username   = each.value.uid
  name       = each.value.name
  groups     = [for g in each.value.groups : authentik_group.groups[g].id]
  email      = each.value.email
  attributes = each.value.attributes
  password   = each.value.password
}
