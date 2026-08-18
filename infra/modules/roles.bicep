// Role assignments for the Web App's system-assigned managed identity:
// - AcrPull on the ACR (so the Web App can pull container images)
// - Cognitive Services OpenAI User on the Foundry (AIServices) account — data-plane
//   access to call model deployments via managed-identity token (no API keys)
//
// The AOAI assignment is scoped to either a freshly-created account in this RG
// or an existing account in another RG/subscription.

param webAppPrincipalId string
param acrName string
param aoaiName string
param aoaiResourceGroup string
param aoaiSubscriptionId string

// Built-in role definition IDs (constant across all Azure subscriptions).
var acrPullRoleId = '7f951dda-4ed3-4680-a7ca-43fe172d538d'
// Cognitive Services OpenAI User — data-plane inference; matches the production finops-agent-ai grants.
var cognitiveServicesOpenAIUserRoleId = '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd'

@description('Azure Container Registry - existing resource.')
resource acr 'Microsoft.ContainerRegistry/registries@2024-11-01-preview' existing = {
  name: acrName
}

@description('ACR Pull User role assignment - https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/authorization/resource-role-assignment')
module acrPullAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: guid(acr.id, webAppPrincipalId, acrPullRoleId)
  params: {
    // Required parameters
    principalId: webAppPrincipalId
    resourceId: acr.id
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', acrPullRoleId)
    // Non-required parameters
    principalType: 'ServicePrincipal'
  }
}

@description('Azure Cognitive Services OpenAI - existing resource.')
resource aoai 'Microsoft.CognitiveServices/accounts@2026-03-01' existing = {
  name: aoaiName
}

@description('Cognitive Services OpenAI User role assignment - https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/authorization/resource-role-assignment')
module aoaiOpenAIUserAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: guid(aoai.id, webAppPrincipalId, cognitiveServicesOpenAIUserRoleId)
  scope: resourceGroup(aoaiSubscriptionId, aoaiResourceGroup)
  params: {
    // Required parameters
    principalId: webAppPrincipalId
    resourceId: aoai.id
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', cognitiveServicesOpenAIUserRoleId)
    // Non-required parameters
    principalType: 'ServicePrincipal'
  }
}

