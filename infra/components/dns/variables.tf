variable "resource_group_name" {
  description = "The name of the existing resource group where DNS zones will be created"
  type        = string
}

variable "main_domain" {
  description = "The main domain name"
  type        = string
  default     = "iamroot.sh"
}

variable "dev_domain" {
  description = "The dev domain name"
  type        = string
  default     = "dev.iamroot.sh"
} 