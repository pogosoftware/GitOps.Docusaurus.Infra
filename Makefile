CHART_PATH=helm/docusaurus-app
RELEASE_NAME=docusaurus
NAMESPACE=docusaurus

create-k3d-cluster:
	k3d cluster create gitops --api-port 6550 -p "8081:80@loadbalancer" --servers 1 --agents 2

add-helm-repos:
	helm repo add argo https://argoproj.github.io/argo-helm
	helm repo update

deploy-argocd: add-helm-repos
	helm upgrade --install argocd argo/argo-cd \
		--namespace argocd --create-namespace \
		--set notifications.enabled=true \
		--set pullRequestGenerator.enabled=true \
		--set configs.params."server\.insecure"=true

deploy-docusaurus-app:
	helm upgrade \
		--install $(RELEASE_NAME) $(CHART_PATH) \
		--namespace $(NAMESPACE) \
		--create-namespace \
		--set image.repository=pogosoftware/docusaurus-app --set image.tag=sha-73f56dd
