param location string
param appServiceName string

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
      linuxFxVersion: 'DOCKER|nginx'
      appSettings: [
        {
          // by default, persist storage is enabled on Linux custom containers, disable since we don't need it
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
        {
          // set to false if you don't use continuous integration via the webhook
          name: 'DOCKER_ENABLE_CI'
          value: 'true' 
        }
      ]
    }
  }
}

output principalId string = appService.identity.principalId
output appServiceResourceName string = appService.name
