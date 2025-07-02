variable "resource_group_name" {
  description = "The name of the existing resource group where AKS will be created"
  type        = string
}

variable "acr_id" {
  description = "The ID of the Azure Container Registry to grant pull access to"
  type        = string
}

variable "dns_zone_name" {
  description = "The name of the DNS Zone where the main record will be created"
  type        = string
}

variable "cluster_name" {
  description = "The name of the AKS cluster"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix specified when creating the managed cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Version of Kubernetes specified when creating the AKS managed cluster"
  type        = string
  default     = "1.32.4"
}

variable "sku_tier" {
  description = "The SKU Tier that should be used for this Kubernetes Cluster"
  type        = string
  default     = "Free"
}

variable "private_cluster_enabled" {
  description = "Should this Kubernetes Cluster have its API server only exposed on internal IP addresses?"
  type        = bool
  default     = false
}

variable "node_count" {
  description = "The initial number of nodes which should exist in this Node Pool"
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "The size of the Virtual Machine"
  type        = string
  default     = "Standard_D2s_v6"
}

variable "max_pods" {
  description = "The maximum number of pods that can run on each agent"
  type        = number
  default     = 220
}

variable "network_plugin" {
  description = "Network plugin to use for networking"
  type        = string
  default     = "azure"
}

variable "load_balancer_sku" {
  description = "Specifies the SKU of the Load Balancer used for this Kubernetes Cluster"
  type        = string
  default     = "standard"
}

variable "admin_group_object_ids" {
  description = "A list of Object IDs of Azure Active Directory Groups which should have Admin Role on the Cluster"
  type        = list(string)
  default     = []
}

variable "azure_rbac_enabled" {
  description = "Is Role Based Access Control based on Azure AD enabled?"
  type        = bool
  default     = true
}

variable "local_account_disabled" {
  description = "If true local accounts will be disabled"
  type        = bool
  default     = true
}

variable "workload_identity_enabled" {
  description = "Specifies whether Azure AD Workload Identity should be enabled for the Cluster"
  type        = bool
  default     = true
}

variable "oidc_issuer_enabled" {
  description = "Enable or Disable the OIDC issuer URL"
  type        = bool
  default     = true
}

variable "image_cleaner_enabled" {
  description = "Specifies whether Image Cleaner is enabled"
  type        = bool
  default     = true
}

variable "image_cleaner_interval_hours" {
  description = "Specifies the interval in hours when images should be cleaned up"
  type        = number
  default     = 72
}

variable "additional_tags" {
  description = "Additional tags to be applied to the resources"
  type        = map(string)
  default     = {}
}
