# Design Document

## Overview
The Azure Resource Group Automation Script is designed to automate the process of creating and managing Azure Resource Groups and associated resources. The script is implemented in PowerShell and utilizes Azure CLI commands for resource provisioning and management.

## Workflow
The script follows a step-by-step workflow to create and manage Azure resources:

#### User Input:
The script prompts the user to enter parameters such as the Resource Group Name, Location, VM Name, Storage Account Name, and VNet Name.

### Resource Group Creation:
The Create-ResourceGroup function is called to create a new Azure Resource Group. It uses the az group create command to create the Resource Group with the specified name and location.

### Resource Deployment:
The script utilizes functions like Create-VM, Create-Storage, and Create-VNet to deploy standard resources within the Resource Group. Each function invokes the corresponding Azure CLI command to create the specified resource, such as a virtual machine, storage account, or virtual network.

### Resource Update (Optional):
The Update-Resources function provides a placeholder for updating resources within the Resource Group. This function can be customized to include specific update logic based on requirements. Currently, it does not perform any updates.

### Resource Group Deletion (Optional):
The Delete-ResourceGroup function allows for the deletion of the entire Resource Group and all associated resources. It utilizes the az group delete command to delete the Resource Group.

##  Error Handling

The script incorporates error handling and validations to ensure smooth execution and proper reporting of errors:
1. Try-catch blocks are used to catch exceptions that may occur during resource creation or deletion.
2. If an error occurs during resource creation, an error message is logged using the Log-Operation function, and the script throws an exception to halt execution.
3. Specific error handling is implemented for the Create-Storage function to check for invalid storage account names and provide a more informative error message.

## Logging
The Log-Operation function is utilized throughout the script to log important actions, such as resource creation, updates, and errors. It writes messages to the console using Write-Host, providing visibility into the script's progress and facilitating troubleshooting.

## Extensibility
The script is designed to be easily extensible:

1. Additional resource deployment or update logic can be added by creating new functions and incorporating the corresponding Azure CLI commands.
2. Customization options include adding more resource types, modifying resource configurations, or implementing specific update logic within the Update-Resources function.