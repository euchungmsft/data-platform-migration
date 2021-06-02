@description('Specifies the Azure location where the key vault should be created.')
param location string = resourceGroup().location 

@allowed([
  'hadoop'
  'hbase'
  'storm'
  'spark'
])
@description('The type of the HDInsight cluster to create.')
param clusterType string

@description('The name of the HDInsight cluster to create.')
param clusterName string

@description('These credentials can be used to submit jobs to the cluster and to log into cluster dashboards.')
param clusterLoginUserName string

@description('The password must be at least 10 characters in length and must contain at least one digit, one non-alphanumeric character, and one upper or lower case letter.')
@secure()
param clusterLoginPassword string

@description('These credentials can be used to remotely access the cluster.')
param sshUserName string

@description('The password must be at least 10 characters in length and must contain at least one digit, one non-alphanumeric character, and one upper or lower case letter.')
@secure()
param sshPassword string

@description('The name of the Azure storage account to be created and be used as the cluster\'s primary storage.')
param clusterStorageAccountName string

@description('The name of the Azure Data Lake Store account to be created and connected to the cluster.')
param adlStoreName string

@description('The tenant ID (guid) of the Azure Active Directory (AAD) tenant where the service principal resides.')
param aadTenantId string

@description('The AAD object ID (guid) of the service principal that represents the HDInsight cluster. The service principal will be given permissions on the root folder of the Data Lake Store account.')
param servicePrincipalObjectId string

@description('The AAD application ID (guid) of the service principal that represents the HDInsight cluster. The service principal will be given permissions on the root folder of the Data Lake Store account.')
param servicePrincipalApplicationId string

@description('The base-64-encoded contents of the PFX certificate file that can be used to authenticate as the service principal that represents the HDInsight cluster.')
@secure()
param servicePrincipalCertificateContents string

@description('The password securing the PFX certificate file that can be used to authenticate as the service principal that represents the HDInsight cluster.')
@secure()
param servicePrincipalCertificatePassword string

@description('The number of nodes in the HDInsight cluster.')
param clusterWorkerNodeCount int = 4

var defaultApiVersion = '2019-06-01-preview'

resource clusterStorageAccountName_resource 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: clusterStorageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    encryption: {
      keySource: 'Microsoft.Storage'
      services: {
        blob: {
          enabled: true
        }
        file: {
          enabled: true
        }
      }
    }
    accessTier: 'Hot' 
    isHnsEnabled: true
    supportsHttpsTrafficOnly: true
  }
}

resource clusterStorageAccountName_default_containerName 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${clusterStorageAccountName}/default/blob1'
  dependsOn: [
    clusterStorageAccountName_resource
  ]
}

resource clusterStorageAccountName_default_shareName 'Microsoft.Storage/storageAccounts/fileServices/shares@2019-06-01' = {
  name: '${clusterStorageAccountName}/default/file01'
  dependsOn: [
    clusterStorageAccountName_resource
  ]
}

var UserAssignedIdentityName = 'uain-001'
var managedIdentityId = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${UserAssignedIdentityName}'

resource UserAssignedIdentityName_resource 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: UserAssignedIdentityName
  location: location
}

/*
resource StorageAccountName_Microsoft_Authorization_subscriptionId 'Microsoft.Storage/storageAccounts/providers/roleAssignments@2018-01-01-preview' = {
  name: '${clusterStorageAccountName}/Microsoft.Authorization/${guid(subscription().subscriptionId)}'
  properties: {
    roleDefinitionId: StorageBlobDataOwner
    principalId: reference(managedIdentityId, '2018-11-30').principalId
  }
  dependsOn: [
    clusterStorageAccountName_resource
    UserAssignedIdentityName_resource
  ]
} 
*/

resource clusterName_resource 'Microsoft.HDInsight/clusters@2018-06-01-preview' = {
  name: clusterName
  location: location
  properties: {
    clusterVersion: '4.0'
    osType: 'Linux'
    clusterDefinition: {
      kind: clusterType
      configurations: {
        gateway: {
          'restAuthCredential.isEnabled': true
          'restAuthCredential.username': clusterLoginUserName
          'restAuthCredential.password': clusterLoginPassword
        }
        clusterIdentity: {
          'clusterIdentity.applicationId': servicePrincipalApplicationId
          'clusterIdentity.certificate': servicePrincipalCertificateContents
          'clusterIdentity.certificatePassword': servicePrincipalCertificatePassword
          'clusterIdentity.aadTenantId': 'https://login.windows.net/${aadTenantId}'
          'clusterIdentity.resourceUri': 'https://management.core.windows.net/'
        }
      }
    }
    identity: {
      type: 'UserAssigned'
      userAssignedIdentities: {
        //'${managedIdentityId}': {}
        //reference(UserAssignedIdentityName_resource.id, '2018-11-30'): {}
        //'/subscriptions/b6d4cd53-eeab-41d1-93a8-665daf75fce1/resourceGroups/210429HDMIGPRJ_KRC/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uain-001': {}
        '${UserAssignedIdentityName_resource.id}': {}
      }
    }  
    storageProfile: {
      storageaccounts: [
        {
          name: '${clusterStorageAccountName}.dfs.core.windows.net'
          isDefault: true
          fileSystem: 'file01'
          key: listKeys(clusterStorageAccountName_resource.id, '2019-06-01').keys[0].value
          resourceId: clusterStorageAccountName_resource.id
          msiResourceId: UserAssignedIdentityName_resource.id
          //msiResourceId: '/subscriptions/b6d4cd53-eeab-41d1-93a8-665daf75fce1/resourcegroups/210429HDMIGPRJ_KRC/providers/Microsoft.ManagedIdentity/userAssignedIdentities/managedid-001'          
          //msiResourceId: reference(UserAssignedIdentityName_resource.id, '2018-11-30') 
          //msiResourceId: '/subscriptions/b6d4cd53-eeab-41d1-93a8-665daf75fce1/resourceGroups/210429HDMIGPRJ_KRC/providers/Microsoft.ManagedIdentity/userAssignedIdentities/uain-001'
        }
      ]
    }
    computeProfile: {
      roles: [
        {
          name: 'headnode'
          targetInstanceCount: 2
          hardwareProfile: {
            vmSize: 'Standard_D3'
          }
          osProfile: {
            linuxOperatingSystemProfile: {
              username: sshUserName
              password: sshPassword
            }
          }
        }
        {
          name: 'workernode'
          targetInstanceCount: clusterWorkerNodeCount
          hardwareProfile: {
            vmSize: 'Standard_D3'
          }
          osProfile: {
            linuxOperatingSystemProfile: {
              username: sshUserName
              password: sshPassword
            }
          }
        }
      ]
    }
  }
}
