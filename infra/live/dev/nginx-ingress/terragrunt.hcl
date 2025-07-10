include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

include "env" {
  path = find_in_parent_folders("env.hcl")
  expose = true
}

dependency "kubernetes" {
  config_path = "../kubernetes"
}

terraform {
  source = "../../..//components/apps/nginx-ingress"
}

inputs = {
  kubernetes_host                     = dependency.kubernetes.outputs.kube_config_host
  kubernetes_client_certificate       = dependency.kubernetes.outputs.kube_config_client_certificate
  kubernetes_client_key               = dependency.kubernetes.outputs.kube_config_client_key
  kubernetes_cluster_ca_certificate   = dependency.kubernetes.outputs.kube_config_cluster_ca_certificate
  service_load_balancer_ip            = dependency.kubernetes.outputs.service_load_balancer_ip
}
