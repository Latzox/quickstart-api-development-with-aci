targetScope = 'subscription'

metadata name = 'Quickstart API Development with ACI'
metadata description = 'This Bicep file deploys an Azure Container Instance running an API'

@description('The name of the Azure Resource Group')
param rgName string = 'rg-dev-api-001'

@description('The location of the deployment')
param location string = 'switzerlandnorth'

@description('The name of the Azure Container Instance')
param aciName string = 'aci-dev-api-001'

@description('The Docker image to deploy')
param dockerImage string = 'latzo.azurecr.io/quickstart-aci-dev-api:latest'

@description('The subscription ID of the Azure Container Registry')
param acrSubId string = '00000000-0000-0000-0000-000000000000'

@description('The name of the Azure Container Registry resource group')
param acrRgName string = 'rg-acr-prod-001'

@description('The name of the Azure Container Registry')
param acrName string = 'latzox'

@description('Role definition ID for ACR pull role.')
param roleDefinitionId string = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '7f951dda-4ed3-4680-a7ca-43fe172d538d'
)

@description('The network configuration for the container')
param network object = {
  port: 443
  protocol: 'Tcp'
}

@description('The performance configuration for the container')
param performance object = {
  cpu: 1
  memoryInGB: '2'
}

@description('The name of the container group')
param containerGroupName string = 'acgdevapi001'

@description('The name of the ACI resource group')
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}

@description('The avm module to deploy the container group')
module containerGroup 'br/public:avm/res/container-instance/container-group:0.4.1' = {
  name: guid(rgName, 'containerGroup')
  scope: rg
  params: {
    containers: [
      {
        name: aciName
        properties: {
          image: dockerImage
          ports: [network]
          resources: {
            requests: performance
          }
          environmentVariables: [
            {
              name: 'CLIENT_ID'
              value: 'TestClientId'
            }
            {
              name: 'CLIENT_SECRET'
              secureValue: 'TestSecret'
            }
          ]
        }
      }
    ]
    name: containerGroupName
    ipAddressPorts: [
      network
    ]
    location: location
    managedIdentities: {
      systemAssigned: true
    }
  }
}

@description('The existing acr resource to assign the pull role to the container group')
resource acr 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' existing = {
  name: acrName
  scope: resourceGroup(acrSubId, acrRgName)
}

@description('The role assignment to assign the pull role to the container group')
module roleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.1' = {
  scope: resourceGroup(acrSubId, acrRgName)
  name: guid(acrRgName, 'roleAssignment')
  params: {
    principalId: containerGroup.outputs.systemAssignedMIPrincipalId
    resourceId: acr.id
    roleDefinitionId: roleDefinitionId
  }
}

output containerGroupFqdn string = containerGroup.outputs.iPv4Address
