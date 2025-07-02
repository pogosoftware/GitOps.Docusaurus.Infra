locals {
  tags = merge(
    data.azurerm_resource_group.this.tags,
    var.additional_tags,
    {
      name                = var.cluster_name
      managed_by          = "terraform"
      terraform_component = "kubernetes"
    }
  )
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  image_cleaner_enabled        = var.image_cleaner_enabled
  image_cleaner_interval_hours = var.image_cleaner_interval_hours

  node_os_upgrade_channel   = "NodeImage"
  maintenance_window_node_os {
    frequency   = "Weekly" 
    interval    = 1
    day_of_week = "Saturday"
    start_time  = "02:00"
    utc_offset  = "+00:00"
    duration    = 4
  }

  automatic_upgrade_channel = "patch"
  maintenance_window_auto_upgrade {
    frequency   = "Weekly"
    interval    = 1
    day_of_week = "Sunday"
    start_time  = "02:00"
    utc_offset  = "+00:00"
    duration    = 4
  }

  sku_tier                  = var.sku_tier
  private_cluster_enabled   = var.private_cluster_enabled
  
  local_account_disabled    = var.local_account_disabled
  workload_identity_enabled = var.workload_identity_enabled
  oidc_issuer_enabled       = var.oidc_issuer_enabled

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    node_count = var.node_count
    vm_size    = var.vm_size
    max_pods   = var.max_pods

    tags = local.tags

    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }
  }

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled     = var.azure_rbac_enabled
    admin_group_object_ids = var.admin_group_object_ids
  }

  network_profile {
    network_plugin    = var.network_plugin
    load_balancer_sku = var.load_balancer_sku
  }

  tags = local.tags
}

# Role assignment for ACR access
resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = var.acr_id
  skip_service_principal_aad_check = true
}

# DNS A record for the cluster
# resource "azurerm_dns_a_record" "this" {
#   name                = "@"
#   zone_name           = var.dns_zone_name
#   resource_group_name = data.azurerm_resource_group.this.name
#   ttl                 = 300
#   target_resource_id  = azurerm_kubernetes_cluster.this.id

#   tags = local.tags
# } 