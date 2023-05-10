param location string = resourceGroup().location
param appServiceName string
param containerRegistryName string
param dockerImageNameTag string

var dockerImage = '${containerRegistryName}.azurecr.io/${dockerImageNameTag}'

module appService 'appservice.bicep' = {
  name: '${appServiceName}-app'  
  params: {
    appServiceName: appServiceName    
    location:	location
  }
}

module roleAssignment 'roleassignment.bicep' = {
  name: '${appServiceName}-roleassignment'  
  params: {
    appServicePrincipalId: appService.outputs.principalId
    containerRegistryName: containerRegistryName
  }
}

module siteConfig 'siteconfig.bicep' = {
  name: '${appServiceName}-siteconfig'
  params: {
    appServiceName: appService.outputs.appServiceResourceName
    dockerImage: dockerImage
  }
}

// optionally set 
module ciTrigger 'citrigger.bicep' = {
  name: '${appServiceName}-citrigger'  
  params: {    
    appServiceName: appService.outputs.appServiceResourceName
    location: location
    containerRegistryName: containerRegistryName
    triggerScope: dockerImageNameTag
  }
}
