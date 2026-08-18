// Base Landing Zone User Defined Types
import {
  tagsType
} from './configuration/shared/lz.type.bicep'

// Workload User Defined Types
import {
  applicationInsightsType
  cognitiveServiceType
  cognitiveServicesProjectType
  containerRegistryType
  logAnalyticsType
} from './configuration/shared/workload.type.bicep'

targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the azd environment. Used to derive resource names and tags.')
param environmentName string

@allowed([
  'australiaeast'
  'brazilsouth'
  'canadacentral'
  'canadaeast'
  'centralus'
  'eastus'
  'eastus2'
  'francecentral'
  'germanywestcentral'
  'italynorth'
  'japaneast'
  'koreacentral'
  'northcentralus'
  'northeurope'
  'norwayeast'
  'polandcentral'
  'southafricanorth'
  'southcentralus'
  'southeastasia'
  'southindia'
  'spaincentral'
  'swedencentral'
  'switzerlandnorth'
  'switzerlandwest'
  'uaenorth'
  'uksouth'
  'westeurope'
  'westus'
  'westus3'
])
@description('Primary Azure region for the resource group and all non-AOAI resources. Restricted to regions where the full stack (App Service, ACR, Log Analytics/App Insights, and gpt-5.6-sol Global Standard) is available, so `azd up` succeeds for any customer.')
param location string

@description('Optional. An object of tag key & value pairs to be appended to the Azure Subscription and Resource Group.')
param tags tagsType?

@description('Required. Name of the resource group.')
param resourceGroupName string

@allowed(['B1', 'B2', 'B3', 'S1', 'S2', 'S3', 'P0V3', 'P1V3', 'P2V3', 'P3V3'])
@description('App Service Plan SKU. B1 (~$13/mo) is the recommended evaluation default; P0V3 matches production.')
param appServicePlanSku string = 'B1'

@description('Optional resource ID of an existing Azure OpenAI account to reuse instead of creating a new one. When set, `aoaiLocation`/`aoaiModelName`/`aoaiModelVersion` are ignored — the deployment must already exist on the existing account.')
param existingAoaiResourceId string = ''

@description('Optional. Configuration for Azure Container Registry.')
param containerRegistryConfiguration containerRegistryType

@description('Optional. Configuration for Log Analytics.')
param logAnalyticsConfiguration logAnalyticsType

@description('Optional. Configuration for Application Insights.')
param applicationInsightsConfiguration applicationInsightsType

@description('Optional. Configuration for Cognitive Services.')
param cognitiveServicesConfiguration cognitiveServiceType

@description('Optional. Configuration for Cognitive Services Project.')
param cognitiveServicesProjectConfiguration cognitiveServicesProjectType

@description('Entra ID multi-tenant app registration client ID. Created automatically by the preprovision hook if empty.')
param entraAppId string = ''

@secure()
@description('Entra ID app registration client secret. Created automatically by the preprovision hook if empty.')
param entraClientSecret string = ''

@description('Entra tenant ID for OAuth — `common` for multi-tenant. Leave default unless restricting to a single tenant.')
param entraTenantId string = 'common'

// Globally-unique short token derived from sub + env so multiple users in the
// same subscription/region don't collide on resource names (ACR, Web App). 
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))

@description('Module: Resource Group - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/resources/resource-group.')
module rg 'br/public:avm/res/resources/resource-group:0.4.4' = {
  params: {
    // Required parameters
    name: resourceGroupName
    // Non-required parameters
    location: location
    tags: tags
  }
}

@description('Module: Main resources.')
module resources 'main-resources.bicep' = {
  name: 'finops-resources'
  scope: resourceGroup(resourceGroupName)
  dependsOn: [rg]
  params: {
    location: location
    resourceToken: resourceToken
    tags: tags
    appServicePlanSku: appServicePlanSku
    existingAoaiResourceId: existingAoaiResourceId
    entraAppId: entraAppId
    entraClientSecret: entraClientSecret
    entraTenantId: entraTenantId
    logAnalyticsConfiguration: logAnalyticsConfiguration
    applicationInsightsConfiguration: applicationInsightsConfiguration
    containerRegistryConfiguration: containerRegistryConfiguration
    cognitiveServicesConfiguration: cognitiveServicesConfiguration
    cognitiveServicesProjectConfiguration: cognitiveServicesProjectConfiguration
  }
}

// ── Outputs ─────────────────────────────────────────────────────────────────
// Surfaced to `azd env` so hooks (and the user) can consume them.

output AZURE_LOCATION string = location
output AZURE_RESOURCE_GROUP string = rg.name
output AZURE_TENANT_ID string = subscription().tenantId
output AZURE_SUBSCRIPTION_ID string = subscription().subscriptionId

output AZURE_CONTAINER_REGISTRY_NAME string = resources.outputs.acrName
output AZURE_CONTAINER_REGISTRY_LOGIN_SERVER string = resources.outputs.acrLoginServer
output AZURE_CONTAINER_REGISTRY_IMAGE string = resources.outputs.containerImageName

output WEB_APP_NAME string = resources.outputs.webAppName
output WEB_APP_HOSTNAME string = resources.outputs.webAppHostname
output WEB_APP_URL string = resources.outputs.webAppUrl
output WEB_APP_PRINCIPAL_ID string = resources.outputs.webAppPrincipalId

output AZURE_OPENAI_ENDPOINT string = resources.outputs.aoaiEndpoint
output AZURE_OPENAI_DEPLOYMENT_NAME string = resources.outputs.aoaiDeploymentName
output AZURE_AI_PROJECT_NAME string = resources.outputs.aiProjectName

output APPLICATIONINSIGHTS_CONNECTION_STRING string = resources.outputs.appInsightsConnectionString
output AZURE_LOG_ANALYTICS_WORKSPACE_ID string = resources.outputs.logAnalyticsWorkspaceId
