variable "kubernetes_host" {
  description = "The Kubernetes cluster server host"
  type        = string
  sensitive   = true
}

variable "kubernetes_client_certificate" {
  description = "Base64 encoded public certificate used by clients to authenticate to the Kubernetes cluster"
  type        = string
  sensitive   = true
}

variable "kubernetes_client_key" {
  description = "Base64 encoded private key used by clients to authenticate to the Kubernetes cluster"
  type        = string
  sensitive   = true
}

variable "kubernetes_cluster_ca_certificate" {
  description = "Base64 encoded public CA certificate used as the root of trust for the Kubernetes cluster"
  type        = string
  sensitive   = true
}

variable "namespace" {
  description = "Kubernetes namespace where nginx-ingress will be installed"
  type        = string
  default     = "ingress-nginx"
}

variable "release_name" {
  description = "Helm release name for nginx-ingress"
  type        = string
  default     = "ingresss-nginx"
}

variable "chart_version" {
  description = "Version of the ingress-nginx chart to deploy"
  type        = string
  default     = "4.13.0"
}

variable "replica_count" {
  description = "Number of controller replicas"
  type        = number
  default     = 1
}

variable "service_type" {
  description = "Type of service for the ingress controller"
  type        = string
  default     = "LoadBalancer"
}

variable "service_load_balancer_ip" {
  description = "Static IP address for the load balancer"
  type        = string
}

variable "service_external_traffic_policy" {
  description = "External traffic policy for the service"
  type        = string
  default     = "Local"
}

variable "min_ready_seconds" {
  description = "Minimum number of seconds for which a newly created pod should be ready"
  type        = number
  default     = 0
}

variable "progress_deadline_seconds" {
  description = "The maximum time in seconds for a deployment to make progress"
  type        = number
  default     = 600
}

variable "node_selector" {
  description = "Node selector for pod assignment"
  type        = map(string)
  default = {
    "kubernetes.io/os" = "linux"
  }
}

variable "additional_service_annotations" {
  description = "Additional annotations for the service"
  type        = map(string)
  default     = {}
}

variable "additional_values" {
  description = "Additional Helm chart values in YAML format"
  type        = string
  default     = ""
} 