
[![Build](https://github.com/Latzox/quickstart-api-development-with-aci/actions/workflows/build.yml/badge.svg)](https://github.com/Latzox/quickstart-api-development-with-aci/actions/workflows/build.yml) [![Dev.to](https://img.shields.io/badge/dev.to-0A0A0A?style=for-the-badge&logo=devdotto&logoColor=white)](https://dev.to/latzo)

# Quickstart API Development with Azure Container Instance (ACI)

This repository contains the code and configurations for deploying and managing applications and infrastructure using Azure Container Instances (ACI), Azure Bicep, and Docker. It is structured to support various stages of development, from infrastructure provisioning to application deployment.

## Repository structure

```bash
.github/
  workflows/
    build.yml                       # Complete Build and Deployment Workflow

app/  
  app.py                            # Python application source code
  Dockerfile                        # Dockerfile for building the application image

infra/ 
  main.bicep                        # Main Bicep template for infrastructure deployment

.gitignore                          # Git ignore rules
LICENSE                             # License information
New-AzureProject.ps1                # Initial setup script
ps-rule.yml                         # Config file for PSRule IaC Validation
README.md                           # Documentation file
```

## How to use

### Clone the repository
Use this template to create a new repository. While this template is designed for Azure Container Instance (ACI) and Azure Container Registry (ACR) services, you can use it as a starting point for any similar project.

### Requirements
Ensure the following prerequisites are met before deploying the necessary resources using the scripts:

- An Azure account with an active Azure Subscription.
- An Azure Container Registry (https://learn.microsoft.com/en-us/azure/container-registry/container-registry-get-started-powershell)
- Azure PowerShell installed locally or access to the Azure Cloud Shell https://shell.azure.com/
- GitHub CLI installed locally or access to the Azure Cloud Shell.

Note: Azure Cloud Shell comes preinstalled with all the required tools.

### Initial Azure setup
The PowerShell function `New-AzureProject` automates the initial setup in Azure and GitHub. It performs the following tasks:

- Creates an Azure AD Service Principal for GitHub Actions workflows.
- Configures GitHub federated identity with Entra ID for secretless authentication in pipelines.
- Assigns necessary Azure RBAC roles for ACI and ACR operations.
- Configures GitHub repository secrets.

You can run the script locally or directly in the Azure Cloud Shell. Ensure you're authenticated to your Azure subscription using Azure PowerShell and to your GitHub repository with the GitHub CLI.

#### Dot source the PowerShell script
```PowerShell
. ./New-AzureProject.ps1
```

#### Call the function with your parameters

```PowerShell
New-AzureProject -DisplayName "Quickstart ACI API Development" `
                -DockerImageName "quickstart-aci-dev-api" `
                -AciSubscriptionId "<SubscriptionID>" `
                -AcrSubscriptionId "<SubscriptionID>" `
                -AcrResourceGroup "rg-acr-prod-001" `
                -AcrName "latzox" `
                -GitHubOrg "Latzox" `
                -RepoName "quickstart-api-development-with-aci" `
                -EnvironmentNames @('build', 'preview')
```
Replace the example parameters above with your specific values.

### Run the GitHub Actions Pipeline
The preconfigured CI/CD pipeline in the .github/workflows/ directory handle resource deployments.

#### How to Run the Pipeline:
Go to Repository > Actions > Build > Run workflow to execute the pipeline.

#### Accessing the Deployed Application
Go to the workflow summary and check the summary output below. You should see the Access URL of the Azure Container Instance.

You have successfully deployed the solution! 🎉

## Contributing
Feel free to open issues or create pull requests for enhancements and fixes.

## License
This project is licensed under the terms of the LICENSE file.

