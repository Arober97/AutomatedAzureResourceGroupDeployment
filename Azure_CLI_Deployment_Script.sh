#!/bin/bash

# Function to log operations
function Log-Operation {
    message="$1"
    echo -e "\n$message"
}

# Function to create Resource Group
function Create-ResourceGroup {
    resourceGroup="$1"
    location="$2"
    Log-Operation "Creating Resource Group with name $resourceGroup and location $location"
    az group create --name $resourceGroup --location $location
    if [[ $? -ne 0 ]]; then
        Log-Operation "Error creating Resource Group"
        exit 1
    fi
}

# Function to create Virtual Machine
function Create-VM {
    resourceGroup="$1"
    location="$2"
    vmName="$3"
    Log-Operation "Creating VM named $vmName in resource group $resourceGroup and location $location"
    az vm create --resource-group $resourceGroup --name $vmName --image UbuntuLTS --admin-username azureuser --generate-ssh-keys
    if [[ $? -ne 0 ]]; then
        Log-Operation "Error creating VM"
        exit 1
    fi
}

# Function to start Virtual Machine
function Start-VM {
    resourceGroup="$1"
    vmName="$2"
    Log-Operation "Starting VM named $vmName in resource group $resourceGroup"
    az vm start --resource-group $resourceGroup --name $vmName
    if [[ $? -ne 0 ]]; then
        Log-Operation "Error starting VM"
        exit 1
    fi
}

# Function to stop Virtual Machine
function Stop-VM {
    resourceGroup="$1"
    vmName="$2"
    Log-Operation "Stopping VM named $vmName in resource group $resourceGroup"
    az vm stop --resource-group $resourceGroup --name $vmName
    if [[ $? -ne 0 ]]; then
        Log-Operation "Error stopping VM"
        exit 1
    fi
}

# Function to restart Virtual Machine
function Restart-VM {
    resourceGroup="$1"
    vmName="$2"
    Log-Operation "Restarting VM named $vmName in resource group $resourceGroup"
    az vm restart --resource-group $resourceGroup --name $vmName
    if [[ $? -ne 0 ]]; then
        Log-Operation "Error restarting VM"
        exit 1
    fi
}

# Function to delete Virtual Machine
function Delete-VM {
    resourceGroup="$1"
    vmName="$2"
    Log-Operation "Deleting VM named $vmName in resource group $resourceGroup"
    az vm delete --resource-group $resourceGroup --name $vmName --yes
    if [[ $? -ne 0 ]]; then
        Log-Operation "Error deleting VM"
        exit 1
    fi
}

# Function to create Storage Account
function Create-Storage {
    resourceGroup="$1"
    location="$2"
    storageAccountName="$3"
    Log-Operation "Creating Storage Account with name $storageAccountName in resource group $resourceGroup and location $location"
    az storage account create --name $storageAccountName --resource-group $resourceGroup --location $location --sku Standard_LRS
    if [[ $? -ne 0 ]]; then
        Log-Operation "Error creating Storage Account"
        exit 1
    fi
}

# Function to create VNet
function Create-VNet {
    resourceGroup="$1"
    location="$2"
    vNetName="$3"
    Log-Operation "Creating VNet named $vNetName in resource group $resourceGroup and location $location"
    az network vnet create --resource-group $resourceGroup --name $vNetName --subnet-name MySubnet
    if [[ $? -ne 0 ]]; then
        Log-Operation "Error creating VNet"
        exit 1
    fi
}

# Function to delete Resource Group
function Delete-ResourceGroup {
    resourceGroup="$1"
    Log-Operation "Deleting Resource Group with name $resourceGroup"
    az group delete --name $resourceGroup --yes --no-wait
    if [[ $? -ne 0 ]]; then
        Log-Operation "Error deleting Resource Group"
        exit 1
    fi
}

# Function to prompt for user input and create resources
function Prompt-And-Create-Resources {
    read -p "Enter the Resource Group Name: " resourceGroup
    read -p "Enter the Location: " location
    read -p "Enter the VM Name: " vmName
    read -p "Enter the Storage Account Name: " storageAccountName
    read -p "Enter the VNet Name: " vNetName

    # Check if the Resource Group already exists
    if [[ $(az group exists --name $resourceGroup) == 'true' ]]; then
        echo "Resource Group $resourceGroup already exists."
    else
        Create-ResourceGroup $resourceGroup $location
        Create-VM $resourceGroup $location $vmName
        Create-Storage $resourceGroup $location $storageAccountName
        Create-VNet $resourceGroup $location $vNetName
    fi
}

# Function to prompt for user input and update resources
function Prompt-And-Update-Resources {
    read -p "Enter the Resource Group Name: " resourceGroup
    read -p "Enter the VM Name: " vmName
    read -p "Do you want to (s)tart, sto(p), (r)estart, or (d)elete the VM? " vmAction
    case "$vmAction" in
        's') Start-VM $resourceGroup $vmName ;;
        'p') Stop-VM $resourceGroup $vmName ;;
        'r') Restart-VM $resourceGroup $vmName ;;
        'd') Delete-VM $resourceGroup $vmName ;;
    esac
}

# Main function to execute the script
function Main {
    az login
    read -p "Do you want to (c)reate or (u)pdate resources? " action
    case "$action" in
        'c') Prompt-And-Create-Resources ;;
        'u') Prompt-And-Update-Resources ;;
    esac
}

# Call the main function to start the script
Main
