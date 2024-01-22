# Get cluster credentials
az aks get-credentials --resource-group $RESOURCE_GROUP_NAME --name $AKS_NAME --overwrite-existing

# Attach Cluster To ACR
az aks update -n $AKS_NAME -g $RESOURCE_GROUP_NAME --attach-acr $ACR_LOGIN_SERVER

# Setup ingress controller

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# helm uninstall ingress-nginx -n ns-app
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --create-namespace --namespace ns-app \
  --set controller.replicaCount=3  \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz \
  --set controller.service.externalTrafficPolicy=Local

# Delete configuration
# kubectl delete -k  _PRJ3_LYON2/kubernetes/overlays/$ENVIRONMENT

# Apply configuration
kubectl apply -k _PRJ3_LYON2/kubernetes/overlays/$ENVIRONMENT

# Apply ingress
kubectl apply -f _PRJ3_LYON2/kubernetes/base/frontend/frontend-ingress.yaml  --namespace ns-app