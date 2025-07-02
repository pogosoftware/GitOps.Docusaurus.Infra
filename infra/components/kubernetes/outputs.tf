output "cluster_id" {
  description = "The ID of the Kubernetes Managed Cluster"
  value       = azurerm_kubernetes_cluster.this.id
}

output "cluster_name" {
  description = "The name of the Kubernetes Managed Cluster"
  value       = azurerm_kubernetes_cluster.this.name
}

output "cluster_fqdn" {
  description = "The FQDN of the Azure Kubernetes Managed Cluster"
  value       = azurerm_kubernetes_cluster.this.fqdn
}

output "cluster_private_fqdn" {
  description = "The FQDN for the Kubernetes Cluster when private link has been enabled"
  value       = azurerm_kubernetes_cluster.this.private_fqdn
}

output "kube_config" {
  description = "Raw Kubernetes config to be used by kubectl and other compatible tools"
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive   = true
}

output "kube_config_host" {
  description = "The Kubernetes cluster server host"
  value       = azurerm_kubernetes_cluster.this.kube_config[0].host
  sensitive   = true
}

output "kube_config_client_certificate" {
  description = "Base64 encoded public certificate used by clients to authenticate to the Kubernetes cluster"
  value       = azurerm_kubernetes_cluster.this.kube_config[0].client_certificate
  sensitive   = true
}

output "kube_config_client_key" {
  description = "Base64 encoded private key used by clients to authenticate to the Kubernetes cluster"
  value       = azurerm_kubernetes_cluster.this.kube_config[0].client_key
  sensitive   = true
}

output "kube_config_cluster_ca_certificate" {
  description = "Base64 encoded public CA certificate used as the root of trust for the Kubernetes cluster"
  value       = azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate
  sensitive   = true
}

output "kubelet_identity" {
  description = "The kubelet identity information"
  value = {
    client_id                 = azurerm_kubernetes_cluster.this.kubelet_identity[0].client_id
    object_id                 = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
    user_assigned_identity_id = azurerm_kubernetes_cluster.this.kubelet_identity[0].user_assigned_identity_id
  }
}

output "identity" {
  description = "The identity information for this Kubernetes Cluster"
  value = {
    type         = azurerm_kubernetes_cluster.this.identity[0].type
    principal_id = azurerm_kubernetes_cluster.this.identity[0].principal_id
    tenant_id    = azurerm_kubernetes_cluster.this.identity[0].tenant_id
  }
}

output "oidc_issuer_url" {
  description = "The OIDC issuer URL that is associated with the cluster"
  value       = azurerm_kubernetes_cluster.this.oidc_issuer_url
}

output "node_resource_group" {
  description = "The auto-generated Resource Group which contains the resources for this Managed Kubernetes Cluster"
  value       = azurerm_kubernetes_cluster.this.node_resource_group
}

# output "dns_record_fqdn" {
#   description = "The FQDN of the DNS record created for the cluster"
#   value       = azurerm_dns_a_record.this.fqdn
# } 