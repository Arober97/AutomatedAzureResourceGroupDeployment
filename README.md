# AutomatedAzureResourceGroupDeployment
This project aims to automate the creation and maintenance of Azure Resource Groups and associated resources using PowerShell and bash scripts. 

# Features
1. Interactive prompts for user input of resource parameters.
2. Creation of a new Resource Group with the specified name and location.
3. Deployment of standard resources including a Virtual Machine, Storage Account, and Virtual Network within the Resource Group.
4. Ability to update resources within the Resource Group (placeholder function provided).
5. Deletion of the Resource Group and all associated resources.

# Prerequisites

Before running the script, make sure you have the following prerequisites:
1. PowerShell or Azure CLI installed on your machine.
2. Azure account and appropriate permissions to create and manage resources.

# How to Use

## Running the Script in Windows 11
To run the script in Windows 11, follow these steps:
1. Clone the repository to your local machine or download the script file.
2. Open PowerShell by searching for "PowerShell" in the Start menu.
3. Navigate to the directory where the script file is located. For example, if the script is in the "Scripts" folder on your desktop, use the following command to navigate to that folder:
```
cd C:\Users\YourUsername\Desktop\Scripts
```
4. Run the script using the following command:
```
./Azure_CLI_Deployment_Script_PS.ps1
```
5. Follow the prompts to input the desired parameters for resource creation.

## Running the Script in Azure Portal
To run the script in Azure Portal, follow these steps:
1. Clone the repository to your local machine or download the script file.
2. Sign in to the Azure Portal at https://portal.azure.com.
3. Open the Azure Cloud Shell by clicking on the shell icon in the top navigation bar.
4. In the Azure Cloud Shell, select PowerShell or Bash as the preferred shell environment.
5. Upload the script file to the Azure Cloud Shell using the "Upload" button in the Cloud Shell toolbar.
6. In the Cloud Shell, navigate to the directory where the script file is located. For example, if the script is in the "clouddrive" folder, use the following command to navigate to that folder:
```
cd clouddrive
```
7. Run the script using the following command:
```
./Azure_CLI_Deployment_Script_PS.ps1
```
8. Follow the prompts to input the desired parameters for resource creation.


### Note: Make sure you have the necessary permissions and have logged in to Azure before running the script in Azure Portal.

Please refer to the script comments and documentation for a better understanding of what each part of the script does and how to customize it according to your requirements.
Expected Output
Upon successful execution, the script will:

Log important actions and error messages to the console.
Display information about the created resources, such as VM details, Storage Account details, and VNet details.
Design Document
For a detailed understanding of the script's design and architecture, please refer to the Design Document.

# License
This project is licensed under the MIT License.
