param appServiceName string
param dockerImage string

resource appService 'Microsoft.Web/sites@2022-03-01' existing = {
  name: appServiceName
}

resource appServiceConfig 'Microsoft.Web/sites/config@2022-03-01' = {
  name: 'web'
  parent: appService
  properties: {
    linuxFxVersion: 'DOCKER|${dockerImage}'
    acrUseManagedIdentityCreds: true
  }
}
