# Parent DNS Zone (example.com)
resource "azurerm_dns_zone" "main" {
  name                = var.main_domain
  resource_group_name = data.azurerm_resource_group.this.name

  tags = merge(
    data.azurerm_resource_group.this.tags,
    {
      Name                 = var.main_domain
      managed_by          = "terraform"
      terraform_component = "dns"
    }
  )
}

# Child DNS Zone (dev.example.com)
resource "azurerm_dns_zone" "dev" {
  name                = var.dev_domain
  resource_group_name = data.azurerm_resource_group.this.name

  tags = merge(
    data.azurerm_resource_group.this.tags,
    {
      name                 = var.dev_domain
      managed_by          = "terraform"
      terraform_component = "dns"
    }
  )
}

# NS record in parent zone to delegate child zone
resource "azurerm_dns_ns_record" "dev_delegation" {
  name                = "dev"
  zone_name           = azurerm_dns_zone.main.name
  resource_group_name = data.azurerm_resource_group.this.name
  ttl                 = 300
  records             = azurerm_dns_zone.dev.name_servers

  tags = merge(
    data.azurerm_resource_group.this.tags,
    {
      managed_by          = "terraform"
      terraform_component = "dns"
    }
  )
} 