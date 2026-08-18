param tags object?
@description('Deployment service tier. "Priority" enables priority processing (faster time-to-first-token at a premium); "Default" is standard processing.')
@allowed(['Default', 'Priority'])
param serviceTier string = 'Priority'
param existingAoaiResourceId string
param cognitiveServicesConfiguration object
param cognitiveServicesProjectConfiguration object

var useExisting = !empty(existingAoaiResourceId)
var existingSegments = split(existingAoaiResourceId, '/')
var existingSubId = useExisting ? existingSegments[2] : subscription().subscriptionId
var existingRg = useExisting ? existingSegments[4] : resourceGroup().name
var existingName = useExisting ? existingSegments[8] : ''

@description('Resource: Cognitive Services account.')
resource newAccount 'Microsoft.CognitiveServices/accounts@2026-03-01' = if (!useExisting) {
  name: cognitiveServicesConfiguration.name
  location: cognitiveServicesConfiguration.location
  tags: tags
  kind: cognitiveServicesConfiguration.kind
  sku: {
    name: cognitiveServicesConfiguration.sku
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    // Foundry account (enables projects/agents/evals later). Key auth OFF —
    // access is managed-identity / Entra token only (no API keys).
    allowProjectManagement: cognitiveServicesConfiguration.allowProjectManagement
    customSubDomainName: cognitiveServicesConfiguration.customSubDomainName
    publicNetworkAccess: cognitiveServicesConfiguration.publicNetworkAccess
    disableLocalAuth: cognitiveServicesConfiguration.disableLocalAuth
  }
}

@description('Resource: Cognitive Services Model Deployment.')
resource modelDeployment 'Microsoft.CognitiveServices/accounts/deployments@2026-03-01' = if (!useExisting) {
  parent: newAccount
  name: cognitiveServicesConfiguration.deployments[0].name
  sku: cognitiveServicesConfiguration.deployments[0].sku
  properties: {
    model: cognitiveServicesConfiguration.deployments[0].model
    // Priority processing (the Foundry portal's "Priority processing" toggle):
    // requests are served with faster time-to-first-token at a price premium.
    serviceTier: serviceTier
  }
}

@description('Resource: Cognitive Services Project.')
resource project 'Microsoft.CognitiveServices/accounts/projects@2026-03-01' = if (!useExisting) {
  parent: newAccount
  name: cognitiveServicesProjectConfiguration.name
  location: cognitiveServicesConfiguration.location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: cognitiveServicesProjectConfiguration.displayName
    description: cognitiveServicesProjectConfiguration.description
  }
}

@description('Resource: Existing Cognitive Services account.')
resource existingAccount 'Microsoft.CognitiveServices/accounts@2026-03-01' existing = if (useExisting) {
  name: existingName
  scope: resourceGroup(existingSubId, existingRg)
}

// Outputs
output endpoint string = useExisting ? existingAccount!.properties.endpoint : newAccount!.properties.endpoint
output accountName string = useExisting ? existingName : newAccount!.name
output deploymentName string = modelDeployment.name
output resourceGroup string = useExisting ? existingRg : resourceGroup().name
output subscriptionId string = useExisting ? existingSubId : subscription().subscriptionId
output projectName string = useExisting ? '' : cognitiveServicesProjectConfiguration.name
