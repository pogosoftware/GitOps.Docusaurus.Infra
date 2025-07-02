locals {
  backend_resource_group_name  = "testing"
  backend_storage_account_name = "tfstates3db82"
  backend_container_name       = "tfstate"

  resource_group_name = "testing"
}

remote_state {
  backend = "azurerm"

  config = {
    resource_group_name  = local.backend_resource_group_name
    storage_account_name = local.backend_storage_account_name
    container_name       = local.backend_container_name
    key                  = "${path_relative_to_include()}/${get_env("ENVIRONMENT", "")}terraform.tfstate"
  }
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "azurerm" {
    resource_group_name  = "${local.backend_resource_group_name}"
    storage_account_name = "${local.backend_storage_account_name}"
    container_name       = "${local.backend_container_name}"
    key                  = "${path_relative_to_include()}/${get_env("ENVIRONMENT", "")}terraform.tfstate"
  }
}
EOF
}
