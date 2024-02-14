output "webapp_url" {
  value = azurerm_linux_web_app.task2webappvd.default_hostname
}

output "webapp_ips" {
  value = azurerm_linux_web_app.task2webappvd.outbound_ip_addresses
}