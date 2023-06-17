# Function to log operations
function Log-Operation ($message) {
    Write-Host "`n$message"
}

# Function to create Resource Group
function Create-ResourceGroup ($resourceGroup, $location) {
    try {
        Log-Operation "Creating Resource Group with name $resourceGroup and location $location"
        az group create --name $resourceGroup --location $location
    }
    catch {
        Log-Operation "Error creating Resource Group: $_"
        throw
    }
}

# Function to create Virtual Machine
function Create-VM ($resourceGroup, $location, $vmName) {
    try {
        Log-Operation "Creating VM named $vmName in resource group $resourceGroup and location $location"
        az vm create --resource-group $resourceGroup --name $vmName --image UbuntuLTS --admin-username azureuser --generate-ssh-keys
    }
    catch {
        Log-Operation "Error creating VM: $_"
        throw
    }
}

# Function to start Virtual Machine
function Start-VM ($resourceGroup, $vmName) {
    try {
        Log-Operation "Starting VM named $vmName in resource group $resourceGroup"
        az vm start --resource-group $resourceGroup --name $vmName
    }
    catch {
        Log-Operation "Error starting VM: $_"
        throw
    }
}

# Function to stop Virtual Machine
function Stop-VM ($resourceGroup, $vmName) {
    try {
        Log-Operation "Stopping VM named $vmName in resource group $resourceGroup"
        az vm stop --resource-group $resourceGroup --name $vmName
    }
    catch {
        Log-Operation "Error stopping VM: $_"
        throw
    }
}

# Function to restart Virtual Machine
function Restart-VM ($resourceGroup, $vmName) {
    try {
        Log-Operation "Restarting VM named $vmName in resource group $resourceGroup"
        az vm restart --resource-group $resourceGroup --name $vmName
    }
    catch {
        Log-Operation "Error restarting VM: $_"
        throw
    }
}

# Function to delete Virtual Machine
function Delete-VM ($resourceGroup, $vmName) {
    try {
        Log-Operation "Deleting VM named $vmName in resource group $resourceGroup"
        az vm delete --resource-group $resourceGroup --name $vmName --yes
    }
    catch {
        Log-Operation "Error deleting VM: $_"
        throw
    }
}

# Function to create Storage Account
function Create-Storage ($resourceGroup, $location, $storageAccountName) {
    try {
        Log-Operation "Creating Storage Account with name $storageAccountName in resource group $resourceGroup and location $location"
        az storage account create --name $storageAccountName --resource-group $resourceGroup --location $location --sku Standard_LRS
    }
    catch {
        if ($_ -like "*AccountNameInvalid*") {
            Log-Operation "Error: Invalid storage account name. Storage account name must be between 3 and 24 characters in length and use numbers and lowercase letters only."
        }
        else {
            Log-Operation "Error creating Storage Account: $_"
        }
        throw
    }
}

# Function to create VNet
function Create-VNet ($resourceGroup, $location, $vNetName) {
    try {
        Log-Operation "Creating VNet named $vNetName in resource group $resourceGroup and location $location"
        az network vnet create --resource-group $resourceGroup --name $vNetName --subnet-name MySubnet
    }
    catch {
        Log-Operation "Error creating VNet: $_"
        throw
    }
}

# Function to delete Resource Group
function Delete-ResourceGroup ($resourceGroup) {
    try {
        Log-Operation "Deleting Resource Group with name $resourceGroup"
        az group delete --name $resourceGroup --yes --no-wait
    }
    catch {
        Log-Operation "Error deleting Resource Group: $_"
        throw
    }
}

# Function to prompt for user input and create resources
function Prompt-And-Create-Resources {
    $resourceGroup = Read-Host -Prompt 'Enter the Resource Group Name'
    $location = Read-Host -Prompt 'Enter the Location'
    $vmName = Read-Host -Prompt 'Enter the VM Name'
    $storageAccountName = Read-Host -Prompt 'Enter the Storage Account Name'
    $vNetName = Read-Host -Prompt 'Enter the VNet Name'

    # Check if the Resource Group already exists
    if ((az group exists --name $resourceGroup) -eq 'true') {
        Log-Operation "Resource Group $resourceGroup already exists."
    }
    else {
        Create-ResourceGroup $resourceGroup $location
        Create-VM $resourceGroup $location $vmName
        Create-Storage $resourceGroup $location $storageAccountName
        Create-VNet $resourceGroup $location $vNetName
    }
}

# Main function to execute the script
function Main {
    try {
        az login
        $action = Read-Host -Prompt 'Do you want to (c)reate or (u)pdate resources?'
        switch ($action) {
            'c' { Prompt-And-Create-Resources }
            'u' {
                $resourceGroup = Read-Host -Prompt 'Enter the Resource Group Name'
                $vmName = Read-Host -Prompt 'Enter the VM Name'
                $vmAction = Read-Host -Prompt 'Do you want to (s)tart, sto(p), (r)estart, or (d)elete the VM?'
                switch ($vmAction) {
                    's' { Start-VM $resourceGroup $vmName }
                    'p' { Stop-VM $resourceGroup $vmName }
                    'r' { Restart-VM $resourceGroup $vmName }
                    'd' { Delete-VM $resourceGroup $vmName }
                }
            }
        }
        # Uncomment the following line if you want to delete the Resource Group at the end of the script
        # Delete-ResourceGroup $resourceGroup
    }
    catch {
        Log-Operation "An error occurred: $_"
    }
}

# Call the main function to start the script
Main
