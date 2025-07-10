output "release_name" {
  description = "The name of the Helm release"
  value       = helm_release.nginx_ingress.name
}

output "release_namespace" {
  description = "The namespace of the Helm release"
  value       = helm_release.nginx_ingress.namespace
}

output "release_version" {
  description = "The version of the Helm release"
  value       = helm_release.nginx_ingress.version
}

output "release_status" {
  description = "The status of the Helm release"
  value       = helm_release.nginx_ingress.status
}

output "chart_version" {
  description = "The chart version used for the release"
  value       = helm_release.nginx_ingress.chart
}

output "namespace_name" {
  description = "The name of the created namespace"
  value       = kubernetes_namespace.nginx_ingress[0].metadata[0].name
}