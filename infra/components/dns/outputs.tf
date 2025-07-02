output "zone_names" {
  description = "DNS zone names as key-value pairs"
  value = {
    prod = azurerm_dns_zone.main.name
    dev  = azurerm_dns_zone.dev.name
  }
}

output "main_zone_name_servers" {
  description = "Name servers for the main DNS zone"
  value       = azurerm_dns_zone.main.name_servers
}

output "dev_zone_name_servers" {
  description = "Name servers for the dev DNS zone"
  value       = azurerm_dns_zone.dev.name_servers
}

output "main_zone_id" {
  description = "ID of the main DNS zone"
  value       = azurerm_dns_zone.main.id
}

output "dev_zone_id" {
  description = "ID of the dev DNS zone"
  value       = azurerm_dns_zone.dev.id
} 