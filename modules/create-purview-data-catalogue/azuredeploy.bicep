@description('Name of the resource')
param purviewname string

@description('Deployment region')
param location string

@description('Deployment environment')
param env string

resource purviewname_env 'Microsoft.Purview/accounts@2020-12-01-preview' = {
  name: concat(purviewname, env)
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    networkAcls: {
      defaultAction: 'Allow'
    }
  }
  sku: {
    name: 'Standard'
    capacity: '4'
  }
  tags: {}
  dependsOn: []
}