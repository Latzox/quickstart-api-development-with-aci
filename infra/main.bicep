targetScope = 'subscription'

metadata name = 'Quickstart API Development with ACI'
metadata description = 'This Bicep file deploys an Azure Container Instance running an API'

@description('The name of the Azure Resource Group')
param rgName string = 'rg-dev-api-001'

@description('The location of the deployment')
param location string = 'switzerlandnorth'

param aciName string = 'aci-dev-api-001'

param dockerImage string = 'latzo.azurecr.io/quickstart-dev-api:latest'

param network object = {
  port: 443
  protocol: 'Tcp'
}

param performance object = {
  cpu: 1
  memoryInGB: '2'
}

param containerGroupName string = 'acgdevapi001'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}

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
