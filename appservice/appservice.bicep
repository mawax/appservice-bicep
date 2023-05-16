param location string
param appServiceName string
param dockerImage string

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: toLower('asp-${appServiceName}')
  location: location
  kind: 'linux'
  sku: {
    name: 'B1'
  }
  properties: {
    reserved: true
  }
}

resource appService 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceName
  location: location
  kind: 'app,linux,container'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|${dockerImage}'
      acrUseManagedIdentityCreds: true
      appSettings: [
        {
          // set to false or remove if you don't use continuous integration via the ACR webhook
          name: 'DOCKER_ENABLE_CI'
          value: 'true'
        }
      ]
    }
  }
}

output principalId string = appService.identity.principalId
output appServiceResourceName string = appService.name
