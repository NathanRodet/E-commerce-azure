# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location $TF_LOCATION --tags project=$PROJECT_NAME environment=$ENVIRONMENT

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $TF_STORAGE_ACCOUNT_NAME --location $TF_LOCATION_STORAGE --min-tls-version TLS1_2 --kind StorageV2 --sku Standard_LRS --encryption-services blob --allow-blob-public-access false --https-only true --tags project=$PROJECT_NAME environment=$ENVIRONMENT

# Create blob container
az storage container create --name $TF_CONTAINER_NAME --account-name $TF_STORAGE_ACCOUNT_NAME

# Cleaning up the resource group and storage account
# az group delete --name $RESOURCE_GROUP_NAME --yes --no-wait
# az storage account delete --name $STORAGE_ACCOUNT_NAME --yes