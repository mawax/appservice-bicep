# Azure App Service with containerized app using System Managed Identity
## Deploying the example
First deploy the container registry:
```pwsh
az group create --location westeurope --name rg-bicepdemo-01

az deployment group create `
    --resource-group rg-bicepdemo-01 `
    --template-file ./acr/main.bicep `
    --parameters containerRegistryName='crbicepdemo01'
```

Then build the docker image and push it to the container registry:
```pwsh
az acr login --name crbicepdemo01

docker build -t crbicepdemo01.azurecr.io/exampleimage:latest ./example-image
docker push crbicepdemo01.azurecr.io/exampleimage:latest
```

Finally, deploy the app service
```pwsh
az deployment group create `
    --resource-group rg-bicepdemo-01 `
    --template-file ./appservice/main.bicep `
    --parameters `
        appServiceName='bicepdemo01' `
        containerRegistryName='crbicepdemo01' `
        dockerImageNameTag='exampleimage:latest'
```
