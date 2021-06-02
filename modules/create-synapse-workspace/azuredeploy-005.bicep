resource workspaceName 'Microsoft.Synapse/workspaces@2019-06-01-preview' = {
  name: workspaceName_var
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    defaultDataLakeStorage: {
      accountUrl: reference(dlsName_var).primaryEndpoints.dfs
      filesystem: dlsFsName
    }
    sqlAdministratorLogin: sqlAdministratorLogin
    sqlAdministratorLoginPassword: sqlAdministratorLoginPassword
    managedVirtualNetwork: 'default'
  }
  dependsOn: [
    dlsName_var
    dlsName_default_dlsFsName
  ]
}

resource workspaceName_allowAll 'Microsoft.Synapse/workspaces/firewallrules@2019-06-01-preview' = if (allowAllConnections == 'true') {
  name: '${workspaceName.name}/allowAll'
  location: location
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}

resource workspaceName_AllowAllWindowsAzureIps 'Microsoft.Synapse/workspaces/firewallrules@2019-06-01-preview' = {
  name: '${workspaceName.name}/AllowAllWindowsAzureIps'
  location: location
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

resource workspaceName_default 'Microsoft.Synapse/workspaces/managedIdentitySqlControlSettings@2019-06-01-preview' = {
  name: '${workspaceName.name}/default'
  location: location
  properties: {
    grantSqlControlToManagedIdentity: {
      desiredState: 'Enabled'
    }
  }
}

resource workspaceName_sqlPoolName 'Microsoft.Synapse/workspaces/sqlPools@2019-06-01-preview' = {
  name: '${workspaceName.name}/${sqlPoolName}'
  location: location
  sku: {
    name: sku
  }
  properties: {
    createMode: 'Default'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
  }
}

resource workspaceName_sqlPoolName_config 'Microsoft.Synapse/workspaces/sqlPools/metadataSync@2019-06-01-preview' = if (metadataSync) {
  name: '${workspaceName_sqlPoolName.name}/config'
  location: location
  properties: {
    enabled: metadataSync
  }
}

resource workspaceName_sparkPoolName 'Microsoft.Synapse/workspaces/bigDataPools@2019-06-01-preview' = if (sparkDeployment == 'true') {
  name: '${workspaceName.name}/${sparkPoolName}'
  location: location
  properties: {
    nodeCount: 5
    nodeSizeFamily: 'MemoryOptimized'
    nodeSize: sparkNodeSize
    autoScale: {
      enabled: true
      minNodeCount: 3
      maxNodeCount: 40
    }
    autoPause: {
      enabled: true
      delayInMinutes: 15
    }
    sparkVersion: '2.4'
  }
}
