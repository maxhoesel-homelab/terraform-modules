locals {
  postfix_length = 6
}

resource "random_string" "postfix" {
  for_each = var.firewall_host_aliases

  length  = local.postfix_length
  special = false
  upper   = false
}

resource "opnsense_firewall_alias" "main" {
  for_each = var.firewall_host_aliases

  name    = "${var.firewall_prefix != "" ? "${var.firewall_prefix}_" : ""}${each.key}_${random_string.postfix[each.key].result}"
  type    = "host"
  content = each.value.hosts
}

resource "opnsense_firewall_filter" "main" {
  depends_on = [opnsense_firewall_alias.main]
  for_each   = var.firewall_filters

  description = each.value.description

  action      = each.value.action
  direction   = "in"
  interface   = each.value.interfaces
  protocol    = each.value.protocol
  ip_protocol = each.value.ip_protocol

  source = {
    invert = each.value.source.invert
    net    = each.value.source.alias != null ? opnsense_firewall_alias.main[each.value.source.alias].name : each.value.source.name
  }

  destination = {
    invert = each.value.destination.invert
    net    = each.value.destination.alias != null ? opnsense_firewall_alias.main[each.value.destination.alias].name : each.value.destination.name
    port   = each.value.destination.port
  }
}

#resource "opnsense_firewall_nat" "main" {
#  depends_on = [opnsense_firewall_alias.main]
#  for_each   = var.firewall_nat
#
#  description = each.value.description
#
#  interface = var.firewall_wan_interface
#  protocol  = each.value.protocol
#
#  destination = {
#    net  = "${var.firewall_wan_interface}ip"
#    port = each.value.nat_port
#  }
#
#  target = {
#    ip   = each.value.target
#    port = each.value.target_port
#  }
#}
