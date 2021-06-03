# Hadoop Migration - Data Platform Migration
This is for Hadoop-Migrations, https://github.com/Azure/Hadoop-Migrations

> **General disclaimer** Please be aware that this template is in private preview. Therefore, expect smaller bugs and issues when working with the solution. Please submit an Issue in GitHub if you come across any issues that you would like us to fix.

[//]: # (**DO NOT COPY - UNDER DEVELOPMENT - MS INTERNAL ONLY - Please be aware that this template is in private preview without any SLA.**)
**DO NOT COPY - UNDER DEVELOPMENT - Please be aware that this template is in private preview without any SLA.**

**** to-be-updated ****

## Description
This is for Hadoop-Migrations

**** to-be-updated ****

## What will be deployed?

By default, all the services which come under the reference architecture are enabled, and you must explicitly disable services that you don't want to be deployed from parameters which prompts in the ARM screen at portal or in the template files  `*.parameters.json` or directly in `*.bicep` 

> Note: Before deploying the resources, we recommend to check registration status of the required resource providers in your subscription. For more information, see [Resource providers for Azure services.](https://docs.microsoft.com/azure/azure-resource-manager/management/resource-providers-and-types)


![Reference Architecture : Modernization](images/end_State_architecture_Modernize.png)

For the reference architecture, the following services are created

- HDInsight
- [Synapse Workspace](https://docs.microsoft.com/azure/synapse-analytics/)
- Azure Databrick
- [Data Factory](https://docs.microsoft.com/azure/data-factory/)
- [Cosmos DB](https://docs.microsoft.com/azure/cosmos-db/introduction)
- Infrastructure
  * [Key Vault](https://docs.microsoft.com/azure/key-vault/general)
  * VNet
  * VM
  * Private DNS Zone

For more details regarding the services that will be deployed, please read the Domains guide in the Hardoop Migration documentation.

## Before you start 

If you don't have an Azure subscription, [create your Azure free account today.](https://azure.microsoft.com/free/)

Components to install

1. Azure CLI
2. Bicep

Things you need to prepare 

1. Resource Group
2. Service Principal and access
3. Public Key for SSH (Optional)

### 1. Resource Group

You need to login first from CLI

```command
az login
```

You'll get prompts at your web brower, if authentication's done successfully, you'll get something like this

```javascript
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    "isDefault": true,
    "managedByTenants": [],
    "name": "xxxxxxxxxxxx",
    "state": "Enabled",
    "tenantId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    "user": {
      "name": "xxxxxxx@xxxxxxxxx.com",
      "type": "user"
    }
  },
```

Get the subscription `id` from login result

Create a resource group by running this

```commands
az group create -l <Your Region> -n <Resource Group Name> --subscription <Your Subscription Id>
```

### 2. Service Principal and access

A service principal needs to be generated for authentication and authorization by Key Vault. Just go to the Azure Portal to find the ID of your subscription. Then start the Cloud Shell or Azure CLI, login to Azure, set the Azure context and execute the following commands to generate the required credentials:

> Note: The purpose of this new Service Principal is to assign least-privilege rights. Therefore, it requires the Contributor role at a resource group scope in order to deploy the resources inside the resource group dedicated to a specific data domain. The Network Contributor role assignment is required as well in this repository in order to assign the resources to the dedicated subnet.

**** to-be-updated ****

```commands
az ad sp create-for-rbac -n <Your App Name>
```

Then you'll get something like this

```javascript
{
  "appId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "displayName": "<Your App Name>",
  "name": "http://<Your App Name>",
  "password": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  "tenant": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

Keep your `appId` and `password` for the following steps

### 3. Public Key for SSH

It's optional only when you want to deploy VMs at VNets for test

[To create and use an SSH public-private key pair for Linux VMs in Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/mac-create-ssh-keys)

```commands
cat ~/.ssh/id_rsa.pub
```

Keep your public key string for the following steps

### Supported Regions

Most of regions where data & analytic components are available, please choose one of regions before you start

## Options to run

Options for deploying this reference architecture

1. Oneclick button to Quickstart
2. CLI

[//]: # (2. Github Action 3. Azure DevOps Action)

## 1. Quickstart Button

- Infrastructure

[![Deploy To Azure](images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fnudbeach%2Fdata-platform-migration%2Fmain%2Fbuild%2Fmain-infra.json) 
[![Visualize](images/visualizebutton.svg?sanitize=true)](http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fnudbeach%2Fdata-platform-migration%2Fmain%2Fbuild%2Fmain-infra.json)

- Key Vault

[![Deploy To Azure](images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fnudbeach%2Fdata-platform-migration%2Fmain%2Fbuild%2Fmain-keyvault.json) 
[![Visualize](images/visualizebutton.svg?sanitize=true)](http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fnudbeach%2Fdata-platform-migration%2Fmain%2Fbuild%2Fmain-keyvault.json)

- Services all-at-once

[![Deploy To Azure](images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fnudbeach%2Fdata-platform-migration%2Fmain%2Fbuild%2Fmain-service-all-at-once.json) 
[![Visualize](images/visualizebutton.svg?sanitize=true)](http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fnudbeach%2Fdata-platform-migration%2Fmain%2Fbuild%2Fmain-service-all-at-once.json)

[//]: # (## 2. Github Action, ## 3. Azure DevOps Action)

## 2. Deploying using CLI

Doublecheck if you've logged in. 

```command
az login
```
Clone this repo to your environment

```command
git clone https://github.com/nudbeach/data-platform-migration.git
```

Create a resource group with location using your subscription id from previous step

```command
az group create -l koreacentral -n <Your Resource Group Name> \
 --subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```
Deploy components by running these commands sequentially

```command
az deployment group create -g <Your Resource Group Name> -f main/main-infra.bicep

az deployment group create -g <Your Resource Group Name> -f main/main-keyvault.bicep

az deployment group create -g <Your Resource Group Name> -f main/main-service-all-at-once.bicep
```

or 

```command
az deployment group create -g <Your Resource Group Name> \
 -f main/main-infra.bicep \
 --parameter main/main-service-infra.json

az deployment group create -g <Your Resource Group Name> \
 -f main/main-service-keyvault.bicep \
 --parameter main/main-service-keyvault.json

az deployment group create -g <Your Resource Group Name> \
 -f main/main-service-all-at-once.bicep \
 --parameter main/main-service-all-at-once.parameters.json
```

`--parameter <parameter filename>` is optional

## Known issues

###Error: MissingSubscriptionRegistration

**Error Message:**
```text
ERROR: Deployment failed. Correlation ID: ***
  "error": ***
    "code": "MissingSubscriptionRegistration",
    "message": "The subscription is not registered to use namespace 'Microsoft.DocumentDB'. See https://aka.ms/rps-not-found for how to register subscriptions.",
    "details": [
      ***
        "code": "MissingSubscriptionRegistration",
        "target": "Microsoft.DocumentDB",
        "message": "The subscription is not registered to use namespace 'Microsoft.DocumentDB'. See https://aka.ms/rps-not-found for how to register subscriptions."

```

**Solution:**
This error message appears, in case during the deployment it tries to create a type of resource which has never been deployed before inside the subscription. We recommend to check prior the deployment whether the required resource providers are registered for your subscription and if needed, register them through the Azure Portal, Azure Powershell or Azure CLI as mentioned here.


## Contributing

This project welcomes contributions and suggestions. Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit <https://cla.opensource.microsoft.com>.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repositories using our CLA.

[//]: # (This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.)