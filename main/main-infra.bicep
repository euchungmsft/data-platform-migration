//// Parameters

@description('Location to create all resources')
param location string = resourceGroup().location

@description('Project name')
param projectName string = 'hdmp002'

@description('VNet address space prefix of Mgmt')
param vnetMgmtaddressSpacePrefix string = '192.168.12.0/23'

@description('Subnet address prefix of Mgmt-subnet1')
param vnetMgmtsubnet1Prefix string = '192.168.12.0/26'

@description('VNet address space prefix of Blue')
param vnetBlueaddressSpacePrefix string = '192.168.14.0/23'

@description('Subnet address prefix of Blue-subnet1')
param vnetBluesubnet1Prefix string = '192.168.14.0/26'

@description('Type of Storage Account')
param saType string = 'Standard_LRS'

// Parameters - VM

@allowed([
  true
  false
])
@description('Prompt to ask if VM creation needed')
param optVMCreation bool = false

@description('VM SKU of Mgmt for test')
param vmMgmtSize string = 'Standard_B2s'

@description('VM SKU of Blue for test')
param vmBlueSize string = 'Standard_B2s'

@description('VM User Name')
param vmUserName string = 'azureuser'

@description('Public Key for all VM access')
param publicKey string = '....'

//// Variables

var vLocation = location
var vProjectName = projectName
var vPublicKey = publicKey

var vVNetMgmtName = 'vnetMgmt'
var vVNetMgmtaddressSpacePrefix = vnetMgmtaddressSpacePrefix
var vVNetMgmtsubnet1Name = 'subnet1'
var vVNetMgmtsubnet1Prefix = vnetMgmtsubnet1Prefix
var vVNetBlueName = 'vnetBlue'
var vVNetBlueaddressSpacePrefix = vnetBlueaddressSpacePrefix
var vVNetBluesubnet1Name = 'subnet1'
var vVNetBluesubnet1Prefix = vnetBluesubnet1Prefix
var vVMMgmtName = 'vmMgmt'
var vVMMgmtSize = vmMgmtSize
var vVMBlueName = 'vmBlue'
var vVMBlueSize = vmBlueSize
var vVMUserName = vmUserName
var vNSGName = '${vProjectName}nsg001'
var vSAName = '${vProjectName}sa001'
var vSAType = saType
var vPrivateDnsZoneName = '${vProjectName}-pdns.com'
var vUserAssignedIdentityName = '${vProjectName}uain001'

//// Stages

// VNet Creation 
module stgVNET '../modules/create-vnets-with-peering/azuredeploy.bicep' = {
  name: 'create-vnets'
  params: {
    location: vLocation
    vNet1Name: vVNetMgmtName
    vNet1Config: {
      addressSpacePrefix: vVNetMgmtaddressSpacePrefix
      subnetName: vVNetMgmtsubnet1Name
      subnetPrefix: vVNetMgmtsubnet1Prefix
      privateEndpointNetworkPolicies: 'Disabled'
    }
    vNet2Name: vVNetBlueName
    vNet2Config: {
      addressSpacePrefix: vVNetBlueaddressSpacePrefix
      subnetName: vVNetBluesubnet1Name
      subnetPrefix: vVNetBluesubnet1Prefix
      privateEndpointNetworkPolicies: 'Disabled'
    }
  }
}

// NSG Creation
module stgNSG '../modules/create-nsg/azuredeploy.bicep' = {
  name: 'create-nsg'
  params: {
    location: vLocation
    nsgName: vNSGName
  }
}

// Storage Account Creation, ADLS Gen2 with a Blob container
module stgSA '../modules/create-adls-gen2-with-blob/azuredeploy.bicep' = {
  name: 'create-storage-account'
  params: {
    location: vLocation
    storageAccountType: vSAType
    storageAccountName: vSAName
    containerName: 'blob1'
  }
}

// Managed Identity Creation assigning Blob Storage Ownder role to the Storage Account
resource userAssignedIdentityName_resource 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: vUserAssignedIdentityName
  location: vLocation
}

module stgUAI '../modules/assign-userassignedidentity/azuredeploy.bicep' = {
  name: 'assign-userassignedidentity-to-storage'
  params: {
     userAssignedIdentityName: vUserAssignedIdentityName
     clusterStorageAccountName: vSAName
  }
  dependsOn: [
    userAssignedIdentityName_resource
    stgSA
  ]
}

// VM Creation for test at Blue, Mgmt each
module stgVMMgmt '../modules/create-vm-simple-linux/azuredeploy.bicep' = if (optVMCreation) {
  name: 'create-vm-mgmt'
  params: {
    location: vLocation
    vmName: vVMMgmtName
    vmSize: vVMMgmtSize
    virtualNetworkName: vVNetMgmtName
    subnetName: vVNetMgmtsubnet1Name
    networkSecurityGroupName : vNSGName
    adminUsername: vVMUserName
    authenticationType: 'sshPublicKey'
    adminPasswordOrKey: vPublicKey
  }
  dependsOn: [
    stgVNET
    stgNSG
  ]
}

module stVMBlue '../modules/create-vm-simple-linux/azuredeploy.bicep' = if (optVMCreation) {
  name: 'create-vm-blue'
  params: {
    location: vLocation
    vmName: vVMBlueName
    vmSize: vVMBlueSize
    virtualNetworkName: vVNetBlueName
    subnetName: vVNetBluesubnet1Name
    networkSecurityGroupName : vNSGName
    adminUsername: vVMUserName
    authenticationType: 'sshPublicKey'
    adminPasswordOrKey: vPublicKey
  }
  dependsOn: [
    stgVNET
    stgNSG
  ]
}

// Private DNS Creation
module stgDNS '../modules/create-private-dns-zone/azuredeploy.bicep' = {
  name: 'create-private-dns'
  params: {
    location: vLocation
    privateDnsZoneName: vPrivateDnsZoneName
    vnetName: vVNetMgmtName
  }
  dependsOn: [
    stgVNET
  ]
}
