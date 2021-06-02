@description('Location for your data factory')
param location string = resourceGroup().location

@description('Name of the instance')
param dataFactoryName string = 'myv2datafactory'

@description('Specifies the resource id of the keyvault that should be linked to the data factory.')
param keyVaultId string

@description('Specifies the id of the subnet which the private endpoint uses.')
param subnetId string

@description('Specifies the ID of the private dns zone for data factory.')
param privateDnsZoneIdDataFactory string

@description('Specifies the ID of the private dns zone for data factory portal.')
param privateDnsZoneIdPortal string 

var defaultManagedVnetIntegrationRuntimeName = 'AutoResolveIntegrationRuntime'

var dataFactoryName_var = dataFactoryName
var keyVaultId_var = keyVaultId
var keyVaultName = last(split(keyVaultId_var, '/'))
var subnetId_var = subnetId
var privateDnsZoneIdDataFactory_var = privateDnsZoneIdDataFactory
var privateDnsZoneIdPortal_var = privateDnsZoneIdPortal
var privateEndpointNameDataFactory_var = '${dataFactoryName_var}-datafactory-private-endpoint'
var privateEndpointNamePortal_var = '${dataFactoryName_var}-portal-private-endpoint'

resource dataFactoryName_resource 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: dataFactoryName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    globalParameters: {}
    publicNetworkAccess: 'Disabled'
  }
}

resource dataFactoryName_default 'Microsoft.DataFactory/factories/managedVirtualNetworks@2018-06-01' = {
  name: '${dataFactoryName_resource.name}/default'
  properties: {}
}

resource dataFactoryName_defaultManagedVnetIntegrationRuntimeName 'Microsoft.DataFactory/factories/integrationRuntimes@2018-06-01' = {
  name: '${dataFactoryName_resource.name}/${defaultManagedVnetIntegrationRuntimeName}'
  properties: {
    type: 'Managed'
    managedVirtualNetwork: {
      type: 'ManagedVirtualNetworkReference'
      referenceName: 'default'
    }
    typeProperties: {
      computeProperties: {
        location: 'AutoResolve'
      }
    }
  }
  dependsOn: [
    dataFactoryName_default
  ]
}

resource dataFactoryName_default_keyVaultName 'Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints@2018-06-01' = if (!empty(keyVaultId_var)) {
  name: '${dataFactoryName_default.name}/${replace(keyVaultName, '-', '')}'
  properties: {
    privateLinkResourceId: keyVaultId_var
    groupId: 'vault'
  }
  dependsOn: [
    dataFactoryName_resource
    dataFactoryName_defaultManagedVnetIntegrationRuntimeName
  ]
}

resource dataFactoryName_keyVaultName 'Microsoft.DataFactory/factories/linkedservices@2018-06-01' = if (!empty(keyVaultId_var)) {
  name: '${dataFactoryName_resource.name}/${replace(keyVaultName, '-', '')}'
  properties: {
    type: 'AzureKeyVault'
    annotations: []
    //additionalProperties: {}
    connectVia: {
      type: 'IntegrationRuntimeReference'
      referenceName: defaultManagedVnetIntegrationRuntimeName
    }
    description: 'Key Vault for data product'
    parameters: {}
    typeProperties: {
      baseUrl: 'https://${keyVaultName}.vault.azure.net/'
    }
  }
  dependsOn: [
    dataFactoryName_default
    dataFactoryName_defaultManagedVnetIntegrationRuntimeName
    //resourceId('Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints', dataFactoryName_var, 'default', replace(keyVaultName, '-', ''))
  ]
} 

resource privateEndpointNameDataFactory 'Microsoft.Network/privateEndpoints@2020-05-01' = {
  name: privateEndpointNameDataFactory_var
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpointNameDataFactory_var
        properties: {
          privateLinkServiceId: dataFactoryName_resource.id
          groupIds: [
            'dataFactory'
          ]
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: subnetId_var
    }
  }
}

resource privateEndpointNameDataFactory_aRecord 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-05-01' = {
  name: '${privateEndpointNameDataFactory.name}/aRecord'
  //location: location
  properties: {
    privateDnsZoneConfigs: [
      {
        name: '${privateEndpointNameDataFactory_var}-aRecord'
        properties: {
          privateDnsZoneId: privateDnsZoneIdDataFactory_var
        }
      }
    ]
  }
}

resource privateEndpointNamePortal 'Microsoft.Network/privateEndpoints@2020-05-01' = {
  name: privateEndpointNamePortal_var
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpointNamePortal_var
        properties: {
          privateLinkServiceId: dataFactoryName_resource.id
          groupIds: [
            'portal'
          ]
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: subnetId_var
    }
  }
}

resource privateEndpointNamePortal_aRecord 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-05-01' = {
  name: '${privateEndpointNamePortal.name}/aRecord'
  //location: location
  properties: {
    privateDnsZoneConfigs: [
      {
        name: '${privateEndpointNamePortal_var}-aRecord'
        properties: {
          privateDnsZoneId: privateDnsZoneIdPortal_var
        }
      }
    ]
  }
}