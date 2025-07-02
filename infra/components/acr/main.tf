resource "azurerm_container_registry" "this" {
  name                = var.acr_name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled

  public_network_access_enabled = var.public_network_access_enabled
  network_rule_bypass_option    = var.network_rule_bypass_option

  tags = merge(
    data.azurerm_resource_group.this.tags,
    {
      Name                = var.acr_name
      managed_by          = "terraform"
      terraform_component = "acr"
    }
  )
} 