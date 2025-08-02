data "authentik_provider_oauth2_config" "app" {
  depends_on  = [authentik_application.app]
  provider_id = authentik_provider_oauth2.app.id
}

output "app_id" {
  value = authentik_application.app.id
}
output "provider_id" {
  value = authentik_provider_oauth2.app.id
}

output "client_id" {
  value = random_string.client_id.result
}

output "client_secret" {
  value     = authentik_provider_oauth2.app.client_secret
  sensitive = true
}

output "configuration_url" {
  value = data.authentik_provider_oauth2_config.app.provider_info_url
}

output "config" {
  value     = replace(replace(replace(replace(var.output_config_template, "$app_name", var.app_name), "$client_id", random_string.client_id.result), "$client_secret", authentik_provider_oauth2.app.client_secret), "$configuration_url", data.authentik_provider_oauth2_config.app.provider_info_url)
  sensitive = true
}
