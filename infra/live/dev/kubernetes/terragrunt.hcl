include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

include "env" {
  path = find_in_parent_folders("env.hcl")
  expose = true
}

dependency "dns" {
  config_path = "../../global/dns"
}

dependency "acr" {
  config_path = "../../global/acr"
}

terraform {
  source = "../../..//components/kubernetes"
}

inputs = {
  resource_group_name = include.root.locals.resource_group_name
  acr_id              = dependency.acr.outputs.acr_id
  dns_zone_name       = dependency.dns.outputs.zone_names["dev"]

  cluster_name        = include.env.locals.cluster_name
  dns_prefix          = include.env.locals.dns_prefix
  kubernetes_version  = include.env.locals.kubernetes_version
}
