# Hadoop Migration - Data Platform Migration
This is for Hadoop-Migrations, https://github.com/Azure/Hadoop-Migrations

> **General disclaimer** Please be aware that this template is in private preview. Therefore, expect smaller bugs and issues when working with the solution. Please submit an Issue in GitHub if you come across any issues that you would like us to fix.

[//]: # (**DO NOT COPY - UNDER DEVELOPMENT - MS INTERNAL ONLY - Please be aware that this template is in private preview without any SLA.**)
**DO NOT COPY - UNDER DEVELOPMENT - Please be aware that this template is in private preview without any SLA.**

## Description
This is for Hadoop-Migrations

## What will be deployed?
- HDInsight 4.0 
- [Synapse Workspace](https://docs.microsoft.com/azure/synapse-analytics/)
- Azure Databrick
- [Data Factory](https://docs.microsoft.com/azure/data-factory/)
- [Cosmos DB](https://docs.microsoft.com/azure/cosmos-db/introduction)
- Infrastructure
  * [Key Vault](https://docs.microsoft.com/azure/key-vault/general)
  * VNet
  * VM
  * Private DNS Zone

## Before you start 

## Options to run
You have following options for deploying this reference architecture:
1. Quickstart
2. Github Action
3. Azure DevOps Action
4. CLI

## 1. Quickstart Button

[![Deploy To Azure](images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-quickstart-templates%2Fmaster%2F101-DDoS-Attack-Prevention%2Fazuredeploy.json)  [![Visualize](images/visualizebutton.svg?sanitize=true)](http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-quickstart-templates%2Fmaster%2F101-DDoS-Attack-Prevention%2Fazuredeploy.json)

## 2. Github Action

## 3. Azure DevOps Action

## 4. Deploying using CLI

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