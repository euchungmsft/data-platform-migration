param artifactsLocation string = deployment().properties.templateLink.uri

@secure()
param artifactsLocationSASToken string = ''

@description('Location for your deployment.')
param location string = resourceGroup().location

@description('This is a Three Letter Acronym for your company name. \'CON\' for Contoso for example.')
param companyTla string

@allowed([
  'true'
  'false'
])
param allowAllConnections string = 'true'

@allowed([
  'true'
  'false'
])
@description('\'True\' deploys an Apache Spark pool as well as a SQL pool. \'False\' does not deploy an Apache Spark pool.')
param sparkDeployment string = 'true'

@allowed([
  'Small'
  'Medium'
  'Large'
])
@description('This parameter will determine the node size if SparkDeployment is true')
param sparkNodeSize string = 'Medium'

@allowed([
  'devtest'
  'poc'
  'prod'
  'shared'
])
@description('Specify deployment type: DevTest, POC, Prod, Shared. This will also be used in the naming convention.')
param deploymentType string = 'poc'

@description('The username of the SQL Administrator')
param sqlAdministratorLogin string

@description('The password for the SQL Administrator')
@secure()
param sqlAdministratorLoginPassword string

@allowed([
  'DW100c'
  'DW200c'
  'DW300c'
  'DW400c'
  'DW500c'
  'DW1000c'
  'DW1500c'
  'DW2000c'
  'DW2500c'
  'DW3000c'
])
@description('Select the SKU of the SQL pool.')
param sku string = 'DW100c'

@description('Choose whether you want to synchronise metadata.')
param metadataSync bool = false

@allowed([
  'Daily'
  'Weekdays'
])
@description('Choose whether to run schedule every day of the week, or only on weekdays')
param Frequency string = 'Weekdays'

@allowed([
  'Dateline Standard Time'
  'Samoa Standard Time'
  'Hawaiian Standard Time'
  'Alaskan Standard Time'
  'Pacific Standard Time'
  'Mountain Standard Time'
  'Mexico Standard Time 2'
  'Central Standard Time'
  'Canada Central Standard Time'
  'Mexico Standard Time'
  'Central America Standard Time'
  'Eastern Standard Time'
  'Atlantic Standard Time'
  'Newfoundland and Labrador Standard Time'
  'E. South America Standard Time'
  'S.A. Eastern Standard Time'
  'Greenland Standard Time'
  'Mid-Atlantic Standard Time'
  'Azores Standard Time'
  'Cape Verde Standard Time'
  'GMT Standard Time'
  'Greenwich Standard Time'
  'Central Europe Standard Time'
  'Central European Standard Time'
  'Romance Standard Time'
  'W. Europe Standard Time'
  'W. Central Africa Standard Time'
  'E. Europe Standard Time'
  'Egypt Standard Time'
  'FLE Standard Time'
  'GTB Standard Time'
  'Israel Standard Time'
  'South Africa Standard Time'
  'Russian Standard Time'
  'Arab Standard Time'
  'E. Africa Standard Time'
  'Arabic Standard Time'
  'Iran Standard Time'
  'Arabian Standard Time'
  'Caucasus Standard Time'
  'Transitional Islamic State of Afghanistan Standard Time'
  'Ekaterinburg Standard Time'
  'West Asia Standard Time'
  'India Standard Time'
  'Nepal Standard Time'
  'Central Asia Standard Time'
  'Sri Lanka Standard Time'
  'Myanmar Standard Time'
  'North Asia Standard Time'
  'China Standard Time'
  'Singapore Standard Time'
  'Taipei Standard Time'
  'North Asia East Standard Time'
  'Korea Standard Time'
  'Tokyo Standard Time'
  'Yakutsk Standard Time'
  'Tasmania Standard Time'
  'Vladivostok Standard Time'
  'West Pacific Standard Time'
  'Central Pacific Standard Time'
  'Fiji Islands Standard Time'
  'New Zealand Standard Time'
  'Tonga Standard Time'
])
@description('Timezone for the schedule. Consult https://msdn.microsoft.com/en-us/library/ms912391(v=winembedded.11).aspx for more information')
param TIME_ZONE string = 'Eastern Standard Time'

@allowed([
  '12:00 AM (  0:00 )'
  '01:00 AM (  1:00 )'
  '02:00 AM (  2:00 )'
  '03:00 AM (  3:00 )'
  '04:00 AM (  4:00 )'
  '05:00 AM (  5:00 )'
  '06:00 AM (  6:00 )'
  '07:00 AM (  7:00 )'
  '08:00 AM (  8:00 )'
  '09:00 AM (  9:00 )'
  '10:00 AM ( 10:00 )'
  '11:00 AM ( 11:00 )'
  '12:00 PM ( 12:00 )'
  '01:00 PM ( 13:00 )'
  '02:00 PM ( 14:00 )'
  '03:00 PM ( 15:00 )'
  '04:00 PM ( 16:00 )'
  '05:00 PM ( 17:00 )'
  '06:00 PM ( 18:00 )'
  '07:00 PM ( 19:00 )'
  '08:00 PM ( 20:00 )'
  '09:00 PM ( 21:00 )'
  '10:00 PM ( 22:00 )'
  '11:00 PM ( 23:00 )'
])
@description('Time of Day when the data warehouse will be resumed')
param ResumeTime string = '09:00 PM ( 21:00 )'

@allowed([
  '12:00 AM (  0:00 )'
  '01:00 AM (  1:00 )'
  '02:00 AM (  2:00 )'
  '03:00 AM (  3:00 )'
  '04:00 AM (  4:00 )'
  '05:00 AM (  5:00 )'
  '06:00 AM (  6:00 )'
  '07:00 AM (  7:00 )'
  '08:00 AM (  8:00 )'
  '09:00 AM (  9:00 )'
  '10:00 AM ( 10:00 )'
  '11:00 AM ( 11:00 )'
  '12:00 PM ( 12:00 )'
  '01:00 PM ( 13:00 )'
  '02:00 PM ( 14:00 )'
  '03:00 PM ( 15:00 )'
  '04:00 PM ( 16:00 )'
  '05:00 PM ( 17:00 )'
  '06:00 PM ( 18:00 )'
  '07:00 PM ( 19:00 )'
  '08:00 PM ( 20:00 )'
  '09:00 PM ( 21:00 )'
  '10:00 PM ( 22:00 )'
  '11:00 PM ( 23:00 )'
])
@description('Time of day when the data warehouse will be paused')
param PauseTime string = '05:00 PM ( 17:00 )'

var synapseName = toLower(concat(companyTla, deploymentType))
var dlsName_var = toLower('dls${companyTla}${deploymentType}')
var dlsFsName = toLower('${dlsName_var}fs1')
var sqlPoolName = toLower('${workspaceName_var}p1')
var workspaceName_var = toLower('${synapseName}ws1')
var sparkPoolName = toLower('synasp1')
var logicApps = [
  'SynapsePauseSchedule'
  'SynapseResumeSchedule'
]

module logicAppPauseDeployment '?' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('nestedtemplates/pausetemplate.json', parameters('_artifactsLocationSASToken')))]*/ = {
  name: 'logicAppPauseDeployment'
  params: {
    logicAppName: logicApps[0]
    Frequency: Frequency
    companyTla: companyTla
    deploymentType: deploymentType
    TIME_ZONE: TIME_ZONE
    PauseTime: PauseTime
    location: location
  }
}

module logicAppResumeDeployment '?' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('nestedtemplates/resumetemplate.json', parameters('_artifactsLocationSASToken')))]*/ = {
  name: 'logicAppResumeDeployment'
  params: {
    logicAppName: logicApps[1]
    Frequency: Frequency
    companyTla: companyTla
    deploymentType: deploymentType
    TIME_ZONE: TIME_ZONE
    ResumeTime: ResumeTime
    location: location
  }
}

resource dlsName 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: dlsName_var
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
    isHnsEnabled: true
  }
}

resource dlsName_default_dlsFsName 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${dlsName_var}/default/${dlsFsName}'
  properties: {
    publicAccess: 'None'
  }
  dependsOn: [
    dlsName_var
  ]
}

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

resource Microsoft_Authorization_roleAssignments_dlsName 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(uniqueString(dlsName_var))
  location: location
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
    principalId: reference(workspaceName.id, '2019-06-01-preview', 'Full').identity.principalId
    principalType: 'ServicePrincipal'
  }
  scope: dlsName
}

module MSIRBACOnResourceGroup0 '?' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('nestedtemplates/logicapproleassignments.json', parameters('_artifactsLocationSASToken')))]*/ = {
  name: 'MSIRBACOnResourceGroup0'
  params: {
    logicAppName: logicApps[0]
  }
  dependsOn: [
    logicAppResumeDeployment
    logicAppPauseDeployment
  ]
}

module MSIRBACOnResourceGroup1 '?' /*TODO: replace with correct path to [uri(parameters('_artifactsLocation'), concat('nestedtemplates/logicapproleassignments.json', parameters('_artifactsLocationSASToken')))]*/ = {
  name: 'MSIRBACOnResourceGroup1'
  params: {
    logicAppName: logicApps[1]
  }
  dependsOn: [
    logicAppResumeDeployment
    logicAppPauseDeployment
  ]
}