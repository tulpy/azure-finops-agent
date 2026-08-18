// Resource-group-scope orchestrator. All app-level resources live here.
targetScope = 'resourceGroup'

param location string
param resourceToken string
param tags object?
param appServicePlanSku string
param existingAoaiResourceId string = ''
param entraAppId string
@secure()
param entraClientSecret string
param entraTenantId string

param containerRegistryConfiguration object
param logAnalyticsConfiguration object
param applicationInsightsConfiguration object
param cognitiveServicesConfiguration object
param cognitiveServicesProjectConfiguration object

var containerImageName = 'finops-agent:latest'

@description('Module: Log Analytics Workspace - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/operational-insights/workspace.')
module workspace 'br/public:avm/res/operational-insights/workspace:0.16.1' = {
  params: {
    // Required parameters
    name: logAnalyticsConfiguration.name
    // Non-required parameters
    skuName: logAnalyticsConfiguration.skuName
    dataRetention: logAnalyticsConfiguration.dataRetention
    location: location
    tags: tags
  }
}

@description('Module: Application Insights - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/insights/component.')
module component 'br/public:avm/res/insights/component:0.8.0' = {
  params: {
    // Required parameters
    name: applicationInsightsConfiguration.name
    workspaceResourceId: workspace.outputs.resourceId
    // Non-required parameters
    disableLocalAuth: applicationInsightsConfiguration.disableLocalAuth
    ingestionMode: applicationInsightsConfiguration.ingestionMode
    kind: applicationInsightsConfiguration.kind
    location: location
    tags: tags
  }
}

// Basic SKU, admin disabled. The Web App pulls images via its system-assigned
// managed identity (AcrPull role assignment in roles.bicep).
@description('Module: Azure Container Registry - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/container-registry/registry.')
module registry 'br/public:avm/res/container-registry/registry:0.12.1' = {
  params: {
    // Required parameters
    name: containerRegistryConfiguration.name
    // Non-required parameters
    acrAdminUserEnabled: containerRegistryConfiguration.acrAdminUserEnabled
    acrSku: containerRegistryConfiguration.sku
    anonymousPullEnabled: containerRegistryConfiguration.anonymousPullEnabled
    location: location
    tags: tags
  }
}

@description('Module: Azure AI Foundry.')
module aoai 'modules/aoai.bicep' = {
  name: 'aoai'
  params: {
    cognitiveServicesConfiguration: cognitiveServicesConfiguration
    cognitiveServicesProjectConfiguration: cognitiveServicesProjectConfiguration
    tags: tags
    existingAoaiResourceId: existingAoaiResourceId
  }
}

@description('Module: App Service Plan - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/web/serverfarm.')
module serverfarm 'br/public:avm/res/web/serverfarm:0.7.0' = {
  params: {
    // Required parameters
    name: 'plan-finops-${resourceToken}'
    // Non-required parameters
    kind: 'linux'
    location: location
    reserved: true
    skuName: appServicePlanSku
    tags: tags
  }
}

@description('Module: Web App - https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/web/site.')
module site 'br/public:avm/res/web/site:0.24.0' = {
  params: {
    // Required parameters
    kind: 'app,linux,container'
    name: 'app-finops-${resourceToken}'
    serverFarmResourceId: serverfarm.outputs.resourceId
    // Non-required parameters
    httpsOnly: true
    location: location
    managedIdentities: {
      systemAssigned: true
    }
    publicNetworkAccess: 'Enabled'
    tags: tags
    siteConfig: {
      appSettings: [
        // Tells App Service which port the container listens on (matches Dockerfile EXPOSE 8080).
        { name: 'WEBSITES_PORT', value: '8080' }
        // CRITICAL: mount the persistent /home Azure Files share into the container.
        // Chat history, Data Protection keys, and persisted identities (refresh
        // tokens) all live under /home — with this 'false' every restart/deploy
        // wiped them: users were silently logged out (cookie decrypt failed with
        // "key not found in the key ring") and all conversations disappeared.
        { name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE', value: 'true' }
        // Root for Copilot SDK session state + identity store on the persistent mount.
        { name: 'COPILOT_HOME', value: '/home/copilot' }
        // The image is heavy (node + .NET + Python + OTel collector); the first
        // cold start can exceed the 230s default. Allow up to 30 min to warm up.
        { name: 'WEBSITES_CONTAINER_START_TIME_LIMIT', value: '1800' }
        { name: 'DOCKER_REGISTRY_SERVER_URL', value: 'https://${registry.outputs.loginServer}' }
        // BYOK Azure OpenAI (Program.cs fail-fast key).
        { name: 'AzureOpenAI__Endpoint', value: aoai.outputs.endpoint }
        { name: 'AzureOpenAI__DeploymentName', value: aoai.outputs.deploymentName }
        // Reasoning effort for reasoning-capable models. 'high' is the tested
        // default; 'xhigh' produced 8+ minute single LLM round-trips.
        { name: 'AzureOpenAI__ReasoningEffort', value: 'high' }
        // Entra ID OAuth (multi-tenant). Empty values disable OAuth gracefully.
        { name: 'Microsoft__ClientId', value: entraAppId }
        { name: 'Microsoft__ClientSecret', value: entraClientSecret }
        { name: 'Microsoft__TenantId', value: entraTenantId }
        // Application Insights — Program.cs reads ApplicationInsights__ConnectionString,
        // entrypoint.sh's OTel collector reads APPLICATIONINSIGHTS_CONNECTION_STRING.
        { name: 'ApplicationInsights__ConnectionString', value: component.outputs.connectionString }
        { name: 'APPLICATIONINSIGHTS_CONNECTION_STRING', value: component.outputs.connectionString }
        { name: 'ASPNETCORE_ENVIRONMENT', value: 'Production' }
      ]
      acrUseManagedIdentityCreds: true
      healthCheckPath: '/api/version'
      alwaysOn: true
      ftpsState: 'Disabled'
      linuxFxVersion: 'DOCKER|${registry.outputs.loginServer}/${containerImageName}'
      minTlsVersion: '1.2'
    }
  }
}

@description('Module: Role assignments.')
module roles 'modules/roles.bicep' = {
  name: 'roles'
  params: {
    webAppPrincipalId: site.outputs.systemAssignedMIPrincipalId!
    acrName: registry.outputs.name
    aoaiName: aoai.outputs.accountName
    aoaiResourceGroup: aoai.outputs.resourceGroup
    aoaiSubscriptionId: aoai.outputs.subscriptionId
  }
}

// Outputs
output acrName string = registry.outputs.name
output acrLoginServer string = registry.outputs.loginServer
output containerImageName string = containerImageName
output webAppName string = site.outputs.name
output webAppHostname string = site.outputs.defaultHostname
output webAppUrl string = 'https://${site.outputs.defaultHostname}'
output webAppPrincipalId string = site.outputs.systemAssignedMIPrincipalId!
output aoaiEndpoint string = aoai.outputs.endpoint
output aoaiDeploymentName string = aoai.outputs.deploymentName
output aiProjectName string = aoai.outputs.projectName
output appInsightsConnectionString string = component.outputs.connectionString
output logAnalyticsWorkspaceId string = workspace.outputs.resourceId
