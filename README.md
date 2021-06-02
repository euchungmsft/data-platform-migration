# Hadoop Migration - Data Platform Migration
This is for Hadoop-Migrations, https://github.com/Azure/Hadoop-Migrations

> **General disclaimer** Please be aware that this template is in private preview. Therefore, expect smaller bugs and issues when working with the solution. Please submit an Issue in GitHub if you come across any issues that you would like us to fix.

[//]: # (**DO NOT COPY - UNDER DEVELOPMENT - MS INTERNAL ONLY - Please be aware that this template is in private preview without any SLA.**)
**DO NOT COPY - UNDER DEVELOPMENT - Please be aware that this template is in private preview without any SLA.**

## Description
This is for Hadoop-Migrations

## What will be deployed?
- HDInsight 4.0 
- Synapse
- Azure Databrick
- Azure Data Factory
- CosmosDB
- Infrastructure
  * KeyVault
  * VNet
  * VM
  * Private DNS Zone

## Before you start 

## Options to run
1. CLI
2. Quickstart
3. Github Action
4. Azure DevOps Action

## 1. Deploying using CLI

## 2. Quickstart Button

## 3. Github Action

## 4. Azure DevOps Action

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