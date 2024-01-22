# Login to the registry
az acr login -n $ACR_LOGIN_SERVER

# Build and Push the images to the registry
az acr build --image adservice:latest --registry $ACR_LOGIN_SERVER _PRJ3_LYON2/adservice
az acr build --image cartservice:latest --registry $ACR_LOGIN_SERVER _PRJ3_LYON2/cartservice/src
az acr build --image checkoutservice:latest --registry $ACR_LOGIN_SERVER _PRJ3_LYON2/checkoutservice
az acr build --image currencyservice:latest --registry $ACR_LOGIN_SERVER _PRJ3_LYON2/currencyservice
az acr build --image emailservice:latest --registry $ACR_LOGIN_SERVER _PRJ3_LYON2/emailservice
az acr build --image frontend:latest --registry $ACR_LOGIN_SERVER _PRJ3_LYON2/frontend
az acr build --image loadgenerator:latest --registry $ACR_LOGIN_SERVER _PRJ3_LYON2/loadgenerator
az acr build --image paymentservice:latest --registry $ACR_LOGIN_SERVER _PRJ3_LYON2/paymentservice
az acr build --image productcatalogservice:latest --registry $ACR_LOGIN_SERVER _PRJ3_LYON2/productcatalogservice
az acr build --image recommendationservice:latest --registry $ACR_LOGIN_SERVER _PRJ3_LYON2/recommendationservice
az acr build --image shippingservice:latest --registry $ACR_LOGIN_SERVER _PRJ3_LYON2/shippingservice
az acr import --name $ACR_LOGIN_SERVER --source docker.io/library/redis:latest --image redis:latest