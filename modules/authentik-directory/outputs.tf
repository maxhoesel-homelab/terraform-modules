output "groups" {
  value = { for g in var.groups : g.name => authentik_group.groups[g.name].id }
}

output "users" {
  value = { for u in var.users : u.uid => authentik_user.users[u.uid].id }
}
