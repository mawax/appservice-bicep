param containerRegistryName string
param appServicePrincipalId string

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2021-09-01' existing = {
  name: containerRegistryName
}

// acrPullDefinitionId is AcrPull: https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#acrpull
var acrPullDefinitionId = '7f951dda-4ed3-4680-a7ca-43fe172d538d'

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(containerRegistry.name, appServicePrincipalId, 'AcrPullSystemAssigned')
  scope: containerRegistry
  properties: {
    principalId: appServicePrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', acrPullDefinitionId)
  }
}
