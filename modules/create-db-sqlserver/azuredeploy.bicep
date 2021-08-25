@secure()
param vulnerabilityAssessments_Default_storageContainerPath string
param servers_sql_krc_001_svr_name string = 'sql-krc-001-svr'
param privateEndpoints_sql_krc_001_pe_externalid string = '/subscriptions/b6d4cd53-eeab-41d1-93a8-665daf75fce1/resourceGroups/TEST2/providers/Microsoft.Network/privateEndpoints/sql-krc-001-pe'

resource servers_sql_krc_001_svr_name_resource 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: servers_sql_krc_001_svr_name
  location: 'koreacentral'
  kind: 'v12.0'
  properties: {
    administratorLogin: 'adm'
    version: '12.0'
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    restrictOutboundNetworkAccess: 'Disabled'
  }
}

resource servers_sql_krc_001_svr_name_CreateIndex 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  name: '${servers_sql_krc_001_svr_name_resource.name}/CreateIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
}

resource servers_sql_krc_001_svr_name_DbParameterization 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  name: '${servers_sql_krc_001_svr_name_resource.name}/DbParameterization'
  properties: {
    autoExecuteValue: 'Disabled'
  }
}

resource servers_sql_krc_001_svr_name_DefragmentIndex 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  name: '${servers_sql_krc_001_svr_name_resource.name}/DefragmentIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
}

resource servers_sql_krc_001_svr_name_DropIndex 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  name: '${servers_sql_krc_001_svr_name_resource.name}/DropIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
}

resource servers_sql_krc_001_svr_name_ForceLastGoodPlan 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  name: '${servers_sql_krc_001_svr_name_resource.name}/ForceLastGoodPlan'
  properties: {
    autoExecuteValue: 'Enabled'
  }
}

resource servers_sql_krc_001_svr_name_Default 'Microsoft.Sql/servers/auditingPolicies@2014-04-01' = {
  name: '${servers_sql_krc_001_svr_name_resource.name}/Default'
  location: 'Korea Central'
  properties: {
    auditingState: 'Disabled'
  }
}

resource Microsoft_Sql_servers_auditingSettings_servers_sql_krc_001_svr_name_Default 'Microsoft.Sql/servers/auditingSettings@2021-02-01-preview' = {
  name: '${servers_sql_krc_001_svr_name_resource.name}/Default'
  properties: {
    retentionDays: 0
    auditActionsAndGroups: []
    isStorageSecondaryKeyInUse: false
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
}

resource servers_sql_krc_001_svr_name_sql_krc_001_db 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  name: '${servers_sql_krc_001_svr_name_resource.name}/sql-krc-001-db'
  location: 'koreacentral'
  sku: {
    name: 'GP_Gen5'
    tier: 'GeneralPurpose'
    family: 'Gen5'
    capacity: 2
  }
  kind: 'v12.0,user,vcore'
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 34359738368
    catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
    zoneRedundant: false
    licenseType: 'LicenseIncluded'
    readScale: 'Disabled'
    requestedBackupStorageRedundancy: 'Local'
    maintenanceConfigurationId: '/subscriptions/b6d4cd53-eeab-41d1-93a8-665daf75fce1/providers/Microsoft.Maintenance/publicMaintenanceConfigurations/SQL_Default'
    isLedgerOn: false
  }
}

resource servers_sql_krc_001_svr_name_master_Default 'Microsoft.Sql/servers/databases/auditingPolicies@2014-04-01' = {
  name: '${servers_sql_krc_001_svr_name}/master/Default'
  location: 'Korea Central'
  properties: {
    auditingState: 'Disabled'
  }
  dependsOn: [
    servers_sql_krc_001_svr_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_auditingSettings_servers_sql_krc_001_svr_name_master_Default 'Microsoft.Sql/servers/databases/auditingSettings@2021-02-01-preview' = {
  name: '${servers_sql_krc_001_svr_name}/master/Default'
  properties: {
    retentionDays: 0
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    servers_sql_krc_001_svr_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_extendedAuditingSettings_servers_sql_krc_001_svr_name_master_Default 'Microsoft.Sql/servers/databases/extendedAuditingSettings@2021-02-01-preview' = {
  name: '${servers_sql_krc_001_svr_name}/master/Default'
  properties: {
    retentionDays: 0
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    servers_sql_krc_001_svr_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_geoBackupPolicies_servers_sql_krc_001_svr_name_master_Default 'Microsoft.Sql/servers/databases/geoBackupPolicies@2014-04-01' = {
  name: '${servers_sql_krc_001_svr_name}/master/Default'
  location: 'Korea Central'
  properties: {
    state: 'Disabled'
  }
  dependsOn: [
    servers_sql_krc_001_svr_name_resource
  ]
}

resource servers_sql_krc_001_svr_name_master_Current 'Microsoft.Sql/servers/databases/ledgerDigestUploads@2021-02-01-preview' = {
  name: '${servers_sql_krc_001_svr_name}/master/Current'
  properties: {}
  dependsOn: [
    servers_sql_krc_001_svr_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_securityAlertPolicies_servers_sql_krc_001_svr_name_master_Default 'Microsoft.Sql/servers/databases/securityAlertPolicies@2021-02-01-preview' = {
  name: '${servers_sql_krc_001_svr_name}/master/Default'
  properties: {
    state: 'Disabled'
    disabledAlerts: [
      ''
    ]
    emailAddresses: [
      ''
    ]
    emailAccountAdmins: false
    retentionDays: 0
  }
  dependsOn: [
    servers_sql_krc_001_svr_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_transparentDataEncryption_servers_sql_krc_001_svr_name_master_Current 'Microsoft.Sql/servers/databases/transparentDataEncryption@2021-02-01-preview' = {
  name: '${servers_sql_krc_001_svr_name}/master/Current'
  properties: {
    state: 'Disabled'
  }
  dependsOn: [
    servers_sql_krc_001_svr_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_vulnerabilityAssessments_servers_sql_krc_001_svr_name_master_Default 'Microsoft.Sql/servers/databases/vulnerabilityAssessments@2021-02-01-preview' = {
  name: '${servers_sql_krc_001_svr_name}/master/Default'
  properties: {
    recurringScans: {
      isEnabled: false
      emailSubscriptionAdmins: true
    }
  }
  dependsOn: [
    servers_sql_krc_001_svr_name_resource
  ]
}

resource Microsoft_Sql_servers_devOpsAuditingSettings_servers_sql_krc_001_svr_name_Default 'Microsoft.Sql/servers/devOpsAuditingSettings@2021-02-01-preview' = {
  name: '${servers_sql_krc_001_svr_name_resource.name}/Default'
  properties: {
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
}

resource servers_sql_krc_001_svr_name_current 'Microsoft.Sql/servers/encryptionProtector@2021-02-01-preview' = {
  name: '${servers_sql_krc_001_svr_name_resource.name}/current'
  kind: 'servicemanaged'
  properties: {
    serverKeyName: 'ServiceManaged'
    serverKeyType: 'ServiceManaged'
    autoRotationEnabled: false
  }
}

resource Microsoft_Sql_servers_extendedAuditingSettings_servers_sql_krc_001_svr_name_Default 'Microsoft.Sql/servers/extendedAuditingSettings@2021-02-01-preview' = {
  name: '${servers_sql_krc_001_svr_name_resource.name}/Default'
  properties: {
    retentionDays: 0
    auditActionsAndGroups: []
    isStorageSecondaryKeyInUse: false
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
}

resource servers_sql_krc_001_svr_name_ServiceManaged 'Microsoft.Sql/servers/keys@2021-02-01-preview' = {
  name: '${servers_sql_krc_001_svr_name_resource.name}/ServiceManaged'
  kind: 'servicemanaged'
  properties: {
    serverKeyType: 'ServiceManaged'
  }
}

resource servers_sql_krc_001_svr_name_sql_krc_001_pe_78bdd3d1_0b67_4fd3_a3ba_2036047cb5e2 'Microsoft.Sql/servers/privateEndpointConnections@2021-02-01-preview' = {
  name: '${servers_sql_krc_001_svr_name_resource.name}/sql-krc-001-pe-78bdd3d1-0b67-4fd3-a3ba-2036047cb5e2'
  properties: {
    privateEndpoint: {
      id: privateEndpoints_sql_krc_001_pe_externalid
    }
    privateLinkServiceConnectionState: {
      status: 'Approved'
      description: 'Auto-approved'
    }
  }
}

resource Microsoft_Sql_servers_securityAlertPolicies_servers_sql_krc_001_svr_name_Default 'Microsoft.Sql/servers/securityAlertPolicies@2021-02-01-preview' = {
  name: '${servers_sql_krc_001_svr_name_resource.name}/Default'
  properties: {
    state: 'Disabled'
    disabledAlerts: [
      ''
    ]
    emailAddresses: [
      ''
    ]
    emailAccountAdmins: false
    retentionDays: 0
  }
}

resource Microsoft_Sql_servers_vulnerabilityAssessments_servers_sql_krc_001_svr_name_Default 'Microsoft.Sql/servers/vulnerabilityAssessments@2021-02-01-preview' = {
  name: '${servers_sql_krc_001_svr_name_resource.name}/Default'
  properties: {
    recurringScans: {
      isEnabled: false
      emailSubscriptionAdmins: true
    }
    storageContainerPath: vulnerabilityAssessments_Default_storageContainerPath
  }
}

resource servers_sql_krc_001_svr_name_sql_krc_001_db_CreateIndex 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  name: '${servers_sql_krc_001_svr_name_sql_krc_001_db.name}/CreateIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [
    servers_sql_krc_001_svr_name_resource
  ]
}

resource servers_sql_krc_001_svr_name_sql_krc_001_db_DbParameterization 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  name: '${servers_sql_krc_001_svr_name_sql_krc_001_db.name}/DbParameterization'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [
    servers_sql_krc_001_svr_name_resource
  ]
}

resource servers_sql_krc_001_svr_name_sql_krc_001_db_DefragmentIndex 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  name: '${servers_sql_krc_001_svr_name_sql_krc_001_db.name}/DefragmentIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [
    servers_sql_krc_001_svr_name_resource
  ]
}

resource servers_sql_krc_001_svr_name_sql_krc_001_db_DropIndex 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  name: '${servers_sql_krc_001_svr_name_sql_krc_001_db.name}/DropIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [
    servers_sql_krc_001_svr_name_resource
  ]
}

resource servers_sql_krc_001_svr_name_sql_krc_001_db_ForceLastGoodPlan 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  name: '${servers_sql_krc_001_svr_name_sql_krc_001_db.name}/ForceLastGoodPlan'
  properties: {
    autoExecuteValue: 'Enabled'
  }
  dependsOn: [
    servers_sql_krc_001_svr_name_resource
  ]
}

resource servers_sql_krc_001_svr_name_sql_krc_001_db_Default 'Microsoft.Sql/servers/databases/auditingPolicies@2014-04-01' = {
  name: '${servers_sql_krc_001_svr_name_sql_krc_001_db.name}/Default'
  location: 'Korea Central'
  properties: {
    auditingState: 'Disabled'
  }
  dependsOn: [
    servers_sql_krc_001_svr_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_auditingSettings_servers_sql_krc_001_svr_name_sql_krc_001_db_Default 'Microsoft.Sql/servers/databases/auditingSettings@2021-02-01-preview' = {
  name: '${servers_sql_krc_001_svr_name_sql_krc_001_db.name}/Default'
  properties: {
    retentionDays: 0
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    servers_sql_krc_001_svr_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_backupLongTermRetentionPolicies_servers_sql_krc_001_svr_name_sql_krc_001_db_default 'Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies@2021-02-01-preview' = {
  name: '${servers_sql_krc_001_svr_name_sql_krc_001_db.name}/default'
  properties: {
    weeklyRetention: 'PT0S'
    monthlyRetention: 'PT0S'
    yearlyRetention: 'PT0S'
    weekOfYear: 0
  }
  dependsOn: [
    servers_sql_krc_001_svr_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_backupShortTermRetentionPolicies_servers_sql_krc_001_svr_name_sql_krc_001_db_default 'Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies@2021-02-01-preview' = {
  name: '${servers_sql_krc_001_svr_name_sql_krc_001_db.name}/default'
  properties: {
    retentionDays: 7
  }
  dependsOn: [
    servers_sql_krc_001_svr_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_extendedAuditingSettings_servers_sql_krc_001_svr_name_sql_krc_001_db_Default 'Microsoft.Sql/servers/databases/extendedAuditingSettings@2021-02-01-preview' = {
  name: '${servers_sql_krc_001_svr_name_sql_krc_001_db.name}/Default'
  properties: {
    retentionDays: 0
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    servers_sql_krc_001_svr_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_geoBackupPolicies_servers_sql_krc_001_svr_name_sql_krc_001_db_Default 'Microsoft.Sql/servers/databases/geoBackupPolicies@2014-04-01' = {
  name: '${servers_sql_krc_001_svr_name_sql_krc_001_db.name}/Default'
  location: 'Korea Central'
  properties: {
    state: 'Disabled'
  }
  dependsOn: [
    servers_sql_krc_001_svr_name_resource
  ]
}

resource servers_sql_krc_001_svr_name_sql_krc_001_db_Current 'Microsoft.Sql/servers/databases/ledgerDigestUploads@2021-02-01-preview' = {
  name: '${servers_sql_krc_001_svr_name_sql_krc_001_db.name}/Current'
  properties: {}
  dependsOn: [
    servers_sql_krc_001_svr_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_securityAlertPolicies_servers_sql_krc_001_svr_name_sql_krc_001_db_Default 'Microsoft.Sql/servers/databases/securityAlertPolicies@2021-02-01-preview' = {
  name: '${servers_sql_krc_001_svr_name_sql_krc_001_db.name}/Default'
  properties: {
    state: 'Disabled'
    disabledAlerts: [
      ''
    ]
    emailAddresses: [
      ''
    ]
    emailAccountAdmins: false
    retentionDays: 0
  }
  dependsOn: [
    servers_sql_krc_001_svr_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_transparentDataEncryption_servers_sql_krc_001_svr_name_sql_krc_001_db_Current 'Microsoft.Sql/servers/databases/transparentDataEncryption@2021-02-01-preview' = {
  name: '${servers_sql_krc_001_svr_name_sql_krc_001_db.name}/Current'
  properties: {
    state: 'Enabled'
  }
  dependsOn: [
    servers_sql_krc_001_svr_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_vulnerabilityAssessments_servers_sql_krc_001_svr_name_sql_krc_001_db_Default 'Microsoft.Sql/servers/databases/vulnerabilityAssessments@2021-02-01-preview' = {
  name: '${servers_sql_krc_001_svr_name_sql_krc_001_db.name}/Default'
  properties: {
    recurringScans: {
      isEnabled: false
      emailSubscriptionAdmins: true
    }
  }
  dependsOn: [
    servers_sql_krc_001_svr_name_resource
  ]
}