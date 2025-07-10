CHART_PATH=helm/docusaurus-app
RELEASE_NAME=docusaurus
NAMESPACE=docusaurus

k3d-cluster-create:
	k3d cluster create gitops \
		--servers 1 \
		--agents 2 \
		--k3s-arg "--disable=traefik@server:*" \
		--api-port 6550 \
		--port "8080:80@loadbalancer" \
		--port "8443:443@loadbalancer"

k3d-cluster-delete:
	k3d cluster delete gitops

helm-repos-add:
	helm repo add argo https://argoproj.github.io/argo-helm
	helm repo add istio https://istio-release.storage.googleapis.com/charts
	helm repo add jetstack https://charts.jetstack.io
	helm repo add oauth2-proxy https://oauth2-proxy.github.io/manifests
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	helm repo add external-dns https://kubernetes-sigs.github.io/external-dns/
	helm repo update

istio-deploy:
	helm upgrade --install istio-base istio/base -n istio-system --set defaultRevision=default --create-namespace
	helm upgrade --install istiod istio/istiod -n istio-system --wait \
		--set global.istioNamespace=istio-system \
		--values manifests/istio/values.yaml
	helm upgrade --install istio-ingress istio/gateway -n istio-ingress --create-namespace --wait \
		--set service.type=LoadBalancer \
		--values manifests/istio/values.yaml

ingress-nginx-deploy:
	 helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
		--namespace ingress-nginx \
  	--create-namespace \
		--set controller.replicaCount=1 \
		--set controller.nodeSelector."kubernetes\.io/os"=linux \
		--set controller.admissionWebhooks.patch.nodeSelector."kubernetes\.io/os"=linux \
		--set controller.service.loadBalancerIP=10.224.0.42 \
		--set controller.service.annotations."service.beta.kubernetes.io/azure-load-balancer-health-probe-request-path"=/healthz \
		--set controller.service.externalTrafficPolicy=Local \
		--set defaultBackend.nodeSelector."kubernetes\.io/os"=linux \
		--set controller.service.type=LoadBalancer \
  	--set controller.minReadySeconds=0 \
  	--set controller.progressDeadlineSeconds=600

certmanager-deploy:
	helm install cert-manager jetstack/cert-manager \
		--namespace cert-manager \
		--create-namespace \
		--values cert-manager.values.yaml

argocd-deploy:
	helm upgrade --install argocd argo/argo-cd \
		--namespace argocd --create-namespace \
		--set notifications.enabled=true \
		--set pullRequestGenerator.enabled=true \
		--set configs.params."server\.insecure"=true

oauth2-deploy:
	helm upgrade --install oauth2-proxy oauth2-proxy/oauth2-proxy \
	--namespace oauth2-proxy --create-namespace \
	-f manifests/oauth2/oauth2-proxy-values.yaml


oauth2-deploy-dev:
	helm upgrade --install oauth2-proxy oauth2-proxy/oauth2-proxy \
	--namespace dev --create-namespace \
	-f manifests/oauth2/oauth2-proxy.dev.values.yaml

oauth2-deploy-apps:
	helm upgrade --install oauth2-proxy oauth2-proxy/oauth2-proxy \
	--namespace apps --create-namespace \
	-f manifests/oauth2/oauth2-proxy.apps.values.yaml


external-dns-deploy:
	helm upgrade --install external-dns external-dns/external-dns \
		--namespace external-dns --create-namespace \
		--values manifests/external-dns/values.yaml

docusaurus-app-deploy:
	helm upgrade \
		--install $(RELEASE_NAME) $(CHART_PATH) \
		--namespace $(NAMESPACE) \
		--create-namespace \
		--set image.repository=pogosoftware/docusaurus-app --set image.tag=sha-73f56dd

