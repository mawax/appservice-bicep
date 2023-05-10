param appServiceName string
param containerRegistryName string
param location string = resourceGroup().location
param triggerScope string

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2021-09-01' existing = {
  name: containerRegistryName
}

resource publishingcreds 'Microsoft.Web/sites/config@2022-03-01' existing = {
  name: '${appServiceName}/publishingcredentials'
}

var webhookUri = publishingcreds.list().properties.scmUri

resource hook 'Microsoft.ContainerRegistry/registries/webhooks@2021-09-01' = {
  name: appServiceName
  parent: containerRegistry
  location: location
  properties: {
    serviceUri: '${webhookUri}/api/registry/webhook'
    scope: triggerScope
    status: 'enabled'
    actions: [
      'push'
    ]
  }
}
