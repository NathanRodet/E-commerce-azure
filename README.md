# Terraform

## Prerequisites

We use Azure CLI to use Terraform with Azure.
<https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli>

Terraform Backend should be deployed by Azure CLI.
<https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli>



### Manual deployment of Terraform Backend

#### AZ CLI Script

```bash
# !/bin/bash

CONTAINER_NAME=tfstate
LOCATION=northeurope
LOCATION_STORAGE=westeurope
ENVIRONMENT=prd
PROJECT_NAME=prj3
RESOURCE_GROUP_NAME=rg-$PROJECT_NAME-$ENVIRONMENT-$LOCATION-001
STORAGE_ACCOUNT_NAME=$CONTAINER_NAME$PROJECT_NAME$ENVIRONMENT

# From working directory
cd scripts/az

./terraform-backend.sh
```

### Accessing Backend

Before deploying manually, create those files in the scripts/terraform directory with the following template :

#### backend.tfvars

```hcl
resource_group_name  = "tfstate"
storage_account_name = "<storage_account_name>"
container_name       = "tfstate"
key                  = "terraform.tfstate"
```

#### variables.tfvars

```hcl
PROJECT_NAME = "<project_name>"
ENVIRONMENT  = "<environment>"
LOCATION     = "<location>"
RESOURCE_GROUPE_NAME = "<resource_group_name>"
```

## Terraform Commands

#### INIT

```bash
terraform init -backend-config="backend.tfvars"
```

#### PLAN

```bash
terraform plan -var-file="variables.tfvars" -var-file="backend.tfvars" -out="plan.tfplan" -input=false -lock=false -var="RESOURCE_GROUP_NAME=$(RESOURCE_GROUP_NAME)" -var="ENVIRONMENT=$(ENVIRONMENT)" -var="LOCATION=$(TF_LOCATION)" -var="PROJECT_NAME=$(PROJECT_NAME)" -var="MYSQL_ADMIN_LOGIN=$(MYSQL_ADMIN_LOGIN)" -var="MYSQL_ADMIN_PASSWORD=$(MYSQL_ADMIN_PASSWORD)" 
```

#### APPLY  

plan.tfplan must be used to ensure the changes will be the same as review in the previous command.

```bash
terraform apply "plan.tfplan"
```

#### DESTROY

```bash
terraform destroy -var-file="variables.tfvars" -var-file="backend.tfvars"
```

# Kubernetes

## Variables (change dev or prd)
```bash
RESOURCE_GROUP_NAME=rg-prj3-prd-northeurope-001
AKS_CLUSTER_NAME=aks-prj3-prd-northeurope-001
ACR_LOGIN_SERVER=acrprj3prdnortheurope001
```

## Kube commands

### Install az aks cli

```powershell
az aks install-cli
```
### Get credentials

```powershell
az aks get-credentials --resource-group $RESOURCE_GROUP_NAME --name $AKS_CLUSTER_NAME
```
### Attach Cluster To ACR
```powershell
az aks update -n $AKS_CLUSTER_NAME -g $RESOURCE_GROUP_NAME --attach-acr $ACR_LOGIN_SERVER
```
## Helm install

# Install via script
```bash
$ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
$ chmod 700 get_helm.sh
$ ./get_helm.sh
```

# Install via chocolatey
```bash
choco install kubernetes-helm
```
# Update helm
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Helm install resources
```bash
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --create-namespace --namespace ns-app \
  --set controller.replicaCount=3  \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz \
  --set controller.service.externalTrafficPolicy=Local
```
# Helm uninstall ingress-nginx -n kube-system

# Apply ingress
```bash
kubectl apply -f ./scripts/kubernetes/base/frontend/frontend-ingress.yaml  --namespace ns-app
```

# Apply overlay dev or prd
```bash
kubectl apply -k ./scripts/kubernetes/overlays/$ENVIRONMENT
```
# Delete  overlay
```bash
kubectl delete -k ./scripts/kubernetes/overlays/$ENVIRONMENT
```