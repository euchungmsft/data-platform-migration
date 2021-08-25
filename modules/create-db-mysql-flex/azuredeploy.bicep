@description('Location of the resources')
param location string = resourceGroup().location

@description('Name of the MySQL instance')
param mySQLSvrName string = 'mysql-krc-001-svr'

@description('Database charset')
param dbCharset string = 'utf8'

@description('Database collation')
param dbCollation string = 'utf8_general_ci'

@description('Default charset')
param defaultCharset string = 'utf8mb4'

@description('Default collation')
param defaultCollation string = 'utf8mb4_0900_ai_ci'

param virtualNetworks_TEST2_vnet_externalid string = '/subscriptions/b6d4cd53-eeab-41d1-93a8-665daf75fce1/resourceGroups/TEST2/providers/Microsoft.Network/virtualNetworks/TEST2-vnet'

resource mySQLSvrName_resource 'Microsoft.DBforMySQL/flexibleServers@2020-07-01-preview' = {
  name: mySQLSvrName
  location: location
  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
  properties: {
    administratorLogin: 'adm'
    storageProfile: {
      storageMB: 20480
      storageIops: 360
      backupRetentionDays: 7
      storageAutogrow: 'Enabled'
    }
    version: '8.0.21'
    sslEnforcement: 'Disabled'
    haEnabled: 'Disabled'
    maintenanceWindow: {
      customWindow: 'Disabled'
      dayOfWeek: 0
      startHour: 0
      startMinute: 0
    }
    replicationRole: 'None'
    delegatedSubnetArguments: {
      subnetArmResourceId: '${virtualNetworks_TEST2_vnet_externalid}/subnets/default'
    }
  }
}

resource mySQLSvrName_information_schema 'Microsoft.DBforMySQL/flexibleServers/databases@2020-07-01-preview' = {
  name: '${mySQLSvrName_resource.name}/information_schema'
  properties: {
    charset: dbCharset
    collation: dbCollation
  }
}

resource mySQLSvrName_mysql 'Microsoft.DBforMySQL/flexibleServers/databases@2020-07-01-preview' = {
  name: '${mySQLSvrName_resource.name}/mysql'
  properties: {
    charset: defaultCharset
    collation: defaultCollation
  }
}

resource mySQLSvrName_performance_schema 'Microsoft.DBforMySQL/flexibleServers/databases@2020-07-01-preview' = {
  name: '${mySQLSvrName_resource.name}/performance_schema'
  properties: {
    charset: defaultCharset
    collation: defaultCollation
  }
}

resource mySQLSvrName_sys 'Microsoft.DBforMySQL/flexibleServers/databases@2020-07-01-preview' = {
  name: '${mySQLSvrName_resource.name}/sys'
  properties: {
    charset: defaultCharset
    collation: defaultCollation
  }
}