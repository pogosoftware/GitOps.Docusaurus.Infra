resource "kubernetes_namespace" "nginx_ingress" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/name"     = "ingress-nginx"
      "app.kubernetes.io/instance" = var.release_name
    }
  }
}

resource "helm_release" "nginx_ingress" {
  name       = var.release_name
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.chart_version
  namespace  = var.namespace

  depends_on = [kubernetes_namespace.nginx_ingress]

  values = [
    yamlencode({
      controller = {
        replicaCount = var.replica_count
        nodeSelector = var.node_selector
        
        admissionWebhooks = {
          patch = {
            nodeSelector = var.node_selector
          }
        }
        
        service = {
          type                  = var.service_type
          loadBalancerIP        = var.service_load_balancer_ip
          externalTrafficPolicy = var.service_external_traffic_policy
          annotations = merge(
            {
              "service.beta.kubernetes.io/azure-load-balancer-health-probe-request-path" = "/healthz"
            },
            var.additional_service_annotations
          )
        }
        
        minReadySeconds         = var.min_ready_seconds
        progressDeadlineSeconds = var.progress_deadline_seconds
      }
      
      defaultBackend = {
        nodeSelector = var.node_selector
      }
    }),
    var.additional_values
  ]
} 