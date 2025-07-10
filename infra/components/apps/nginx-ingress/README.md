# NGINX Ingress Controller Component

This Terraform component deploys the NGINX Ingress Controller using the official Helm chart. It creates a LoadBalancer service with a static IP address and configures the controller with Azure-specific settings.

## Features

- **NGINX Ingress Controller** deployed via official Helm chart
- **LoadBalancer service** with static IP configuration
- **Azure health probe** configuration for load balancer
- **Node selector** for Linux nodes
- **Configurable replica count** for high availability
- **Namespace management** with optional creation
- **External traffic policy** set to Local for source IP preservation
- **Customizable service annotations** and additional values

## Prerequisites

- Kubernetes cluster (provided by the kubernetes component)
- Kubernetes credentials from the kubernetes component outputs
- Static IP address available in the cluster's subnet

## Usage

### Basic Usage

```hcl
module "nginx_ingress" {
  source = "./infra/components/apps/nginx-ingress"

  # Kubernetes credentials from kubernetes component
  kubernetes_host                     = var.kubernetes_host
  kubernetes_client_certificate       = var.kubernetes_client_certificate
  kubernetes_client_key               = var.kubernetes_client_key
  kubernetes_cluster_ca_certificate   = var.kubernetes_cluster_ca_certificate

  # Basic configuration
  replica_count              = 2
  service_load_balancer_ip   = "10.224.0.42"
}
```

### Advanced Usage

```hcl
module "nginx_ingress" {
  source = "./infra/components/apps/nginx-ingress"

  # Kubernetes credentials from kubernetes component
  kubernetes_host                     = var.kubernetes_host
  kubernetes_client_certificate       = var.kubernetes_client_certificate
  kubernetes_client_key               = var.kubernetes_client_key
  kubernetes_cluster_ca_certificate   = var.kubernetes_cluster_ca_certificate

  # Custom configuration
  namespace                  = "custom-ingress"
  release_name              = "custom-nginx"
  chart_version             = "4.13.0"
  replica_count             = 3
  service_load_balancer_ip  = "10.224.0.42"
  
  # Additional service annotations
  additional_service_annotations = {
    "service.beta.kubernetes.io/azure-load-balancer-internal" = "true"
  }

  # Additional Helm values
  additional_values = yamlencode({
    controller = {
      resources = {
        requests = {
          cpu    = "100m"
          memory = "128Mi"
        }
        limits = {
          cpu    = "500m"
          memory = "512Mi"
        }
      }
    }
  })
}
```

### Integration with Kubernetes Component

```hcl
# Kubernetes cluster
module "kubernetes" {
  source = "./infra/components/kubernetes"
  
  resource_group_name = "my-resource-group"
  cluster_name        = "my-aks-cluster"
  dns_prefix          = "myaks"
  # ... other variables
}

# NGINX Ingress Controller
module "nginx_ingress" {
  source = "./infra/components/apps/nginx-ingress"

  # Pass credentials from kubernetes component
  kubernetes_host                     = module.kubernetes.kube_config_host
  kubernetes_client_certificate       = module.kubernetes.kube_config_client_certificate
  kubernetes_client_key               = module.kubernetes.kube_config_client_key
  kubernetes_cluster_ca_certificate   = module.kubernetes.kube_config_cluster_ca_certificate

  replica_count              = 2
  service_load_balancer_ip   = "10.224.0.42"
  
  depends_on = [module.kubernetes]
}
```

## Configuration

The component uses the following configuration matching the Makefile example:

- **Repository**: `https://kubernetes.github.io/ingress-nginx`
- **Chart**: `ingress-nginx`
- **Service Type**: LoadBalancer
- **Static IP**: 10.224.0.42 (configurable)
- **External Traffic Policy**: Local
- **Health Probe**: Azure load balancer health probe at `/healthz`
- **Node Selector**: Linux nodes only

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| kubernetes_host | The Kubernetes cluster server host | `string` | n/a | yes |
| kubernetes_client_certificate | Base64 encoded public certificate for cluster authentication | `string` | n/a | yes |
| kubernetes_client_key | Base64 encoded private key for cluster authentication | `string` | n/a | yes |
| kubernetes_cluster_ca_certificate | Base64 encoded public CA certificate for cluster trust | `string` | n/a | yes |
| namespace | Kubernetes namespace where nginx-ingress will be installed | `string` | `"ingress-nginx"` | no |
| create_namespace | Create the namespace if it does not exist | `bool` | `true` | no |
| release_name | Helm release name for nginx-ingress | `string` | `"ingress-nginx"` | no |
| chart_version | Version of the ingress-nginx chart to deploy | `string` | `"4.13.0"` | no |
| replica_count | Number of controller replicas | `number` | `1` | no |
| service_type | Type of service for the ingress controller | `string` | `"LoadBalancer"` | no |
| service_load_balancer_ip | Static IP address for the load balancer | `string` | `"10.224.0.42"` | no |
| service_external_traffic_policy | External traffic policy for the service | `string` | `"Local"` | no |
| min_ready_seconds | Minimum seconds for newly created pod to be ready | `number` | `0` | no |
| progress_deadline_seconds | Maximum time in seconds for deployment to make progress | `number` | `600` | no |
| node_selector | Node selector for pod assignment | `map(string)` | `{"kubernetes.io/os" = "linux"}` | no |
| additional_service_annotations | Additional annotations for the service | `map(string)` | `{}` | no |
| additional_values | Additional Helm chart values in YAML format | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| release_name | The name of the Helm release |
| release_namespace | The namespace of the Helm release |
| release_version | The version of the Helm release |
| release_status | The status of the Helm release |
| chart_version | The chart version used for the release |
| namespace_name | The name of the created namespace |

## Azure Configuration

The component automatically configures Azure-specific settings:

- **Health Probe**: Sets up Azure load balancer health probe request path to `/healthz`
- **Load Balancer IP**: Uses the specified static IP address
- **External Traffic Policy**: Set to `Local` to preserve client source IP addresses

## High Availability

For production deployments, consider:

- Setting `replica_count` to 2 or more
- Using pod anti-affinity rules via `additional_values`
- Configuring resource requests and limits
- Setting up monitoring and alerting

## Security Considerations

- All Kubernetes credentials are marked as sensitive
- Uses certificate-based authentication to the cluster
- Deploys to a dedicated namespace with proper labels
- Node selector ensures pods run only on Linux nodes

## Troubleshooting

### Common Issues

1. **Static IP not available**: Ensure the specified IP is available in your cluster's subnet
2. **Namespace already exists**: Set `create_namespace = false` if using an existing namespace
3. **Chart version compatibility**: Verify the chart version is compatible with your Kubernetes version

### Verification

```bash
# Check deployment status
kubectl get pods -n ingress-nginx

# Check service and load balancer
kubectl get svc -n ingress-nginx

# Check ingress controller logs
kubectl logs -n ingress-nginx deployment/ingress-nginx-controller
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| helm | 3.0.2 |
| kubernetes | 2.35.1 |

## File Structure

Following the established project patterns:

- `main.tf`: Main resource definitions
- `variables.tf`: Variable declarations  
- `outputs.tf`: Output definitions
- `providers.tf`: Provider configurations
- `versions.tf`: Provider version constraints
- `README.md`: Component documentation 