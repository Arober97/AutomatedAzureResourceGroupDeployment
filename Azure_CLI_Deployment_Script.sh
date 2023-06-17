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
    try {
        Log-Operation "Creating Resource Group with name $resourceGroup and location $location"
        az group create --name $resourceGroup --location $location
    }
    catch {
        Log-Operation "Error creating Resource Group: $?"
        exit 1
    }
}

# Function to create Virtual Machine
function Create-VM {
    resourceGroup="$1"
    location="$2"
    vmName="$3"
    try {
        Log-Operation "Creating VM named $vmName in resource group $resourceGroup and location $location"
        az vm create --resource-group $resourceGroup --name $vmName --image UbuntuLTS --admin-username azureuser --generate-ssh-keys
    }
    catch {
        Log-Operation "Error creating VM: $?"
        exit 1
    }
}

# Function to create Storage Account
function Create-Storage {
    resourceGroup="$1"
    location="$2"
    storageAccountName="$3"
    try {
        Log-Operation "Creating Storage Account with name $storageAccountName in resource group $resourceGroup and location $location"
        az storage account create --name $storageAccountName --resource-group $resourceGroup --location $location --sku Standard_LRS
    }
    catch {
        Log-Operation "Error creating Storage Account: $?"
        exit 1
    }
}

# Function to create VNet
function Create-VNet {
    resourceGroup="$1"
    location="$2"
    vNetName="$3"
    try {
        Log-Operation "Creating VNet named $vNetName in resource group $resourceGroup and location $location"
        az network vnet create --resource-group $resourceGroup --name $vNetName --subnet-name MySubnet
    }
    catch {
        Log-Operation "Error creating VNet: $?"
        exit 1
    }
}

# Function to delete Resource Group
function Delete-ResourceGroup {
    resourceGroup="$1"
    try {
        Log-Operation "Deleting Resource Group with name $resourceGroup"
        az group delete --name $resourceGroup --yes --no-wait
    }
    catch {
        Log-Operation "Error deleting Resource Group: $?"
        exit 1
    }
}

# Function to update resources in the Resource Group
function Update-Resources {
    resourceGroup="$1"
    try {
        Log-Operation "Updating resources in Resource Group $resourceGroup"
        # Add your update logic here
    }
    catch {
        Log-Operation "Error updating resources: $?"
        exit 1
    }
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

# Main function to execute the script
function Main {
    try {
        az login
        Prompt-And-Create-Resources
        # Uncomment the following line if you want to update the resources
        # Update-Resources $resourceGroup
        # Uncomment the following line if you want to delete the Resource Group at the end of the script
        # Delete-ResourceGroup $resourceGroup
    }
    catch {
        Log-Operation "An error occurred: $?"
        exit 1
    }
}

# Call the main function to start the script
Main

