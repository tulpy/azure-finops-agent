// This file contains shared configuration values that are used across multiple IaC modules using the Bicep export feature - https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-import

// Azure Region Identifiers
@export()
var locId = {
  australiacentral: 'auc'
  australiacentral2: 'auc2'
  australiaeast: 'aue'
  australiasoutheast: 'ause'
  brazilsouth: 'brs'
  brazilsoutheast: 'brse'
  canadacentral: 'canc'
  canadaeast: 'cane'
  centralindia: 'cin'
  centralus: 'cus'
  centraluseuap: 'cuseuap'
  eastasia: 'ea'
  eastus: 'eus'
  eastus2: 'eus2'
  eastus2euap: 'eus2euap'
  francecentral: 'frc'
  francesouth: 'frs'
  germanynorth: 'gern'
  germanywestcentral: 'gerwc'
  japaneast: 'jae'
  japanwest: 'jaw'
  jioindiacentral: 'jioinc'
  jioindiawest: 'jioinw'
  koreacentral: 'koc'
  koreasouth: 'kors'
  northcentralus: 'ncus'
  northeurope: 'neu'
  norwayeast: 'nore'
  norwaywest: 'norw'
  southafricanorth: 'san'
  southafricawest: 'saw'
  southcentralus: 'scus'
  southeastasia: 'sea'
  southindia: 'sin'
  swedencentral: 'swc'
  switzerlandnorth: 'swn'
  switzerlandwest: 'sww'
  uaecentral: 'uaec'
  uaenorth: 'uaen'
  uksouth: 'uks'
  ukwest: 'ukw'
  westcentralus: 'wcus'
  westeurope: 'weu'
  westindia: 'win'
  westus: 'wus'
  westus2: 'wus2'
  westus3: 'wus3'
}

// Azure Resource Identifiers
@export()
var resId = {
  aiFoundry: 'aif'
  apiManagement: 'apim'
  appConfigStore: 'appc'
  appInsights: 'aai'
  appServicePlan: 'asp'
  bingSearch: 'bs'
  communicationServices: 'acs'
  containerAppsEnvironment: 'cae'
  containerRegistry: 'acr'
  cosmosDB: 'cos'
  emailCommunicationServices: 'ecs'
  eventHubNamespace: 'ehn'
  frontDoor: 'afd'
  keyVault: 'akv'
  logAnalyticsWorkspace: 'law'
  networkSecurityGroup: 'nsg'
  openAI: 'aif'
  resourceGroup: 'arg'
  routeTable: 'udr'
  searchServices: 'sea'
  speechServices: 'ass'
  storageAccount: 'sta'
  userAssignedIdentity: 'uai'
  virtualNetwork: 'vnt'
  webApplicationFirewall: 'waf'
}

// Azure Resource delimiters
@export()
var delimiter = {
  dash: '-'
  empty: ''
}

// Common Resource Groups across Azure Subscriptions
@export()
var commonResourceGroupNames = [
  'alertsRG'
  'networkWatcherRG'
]

@export()
var serviceHealthAlerts = [
  'Resource Health Unhealthy'
  'Service Health Advisory'
  'Service Health Incident'
  'Service Health Maintenance'
  'Service Health Security'
]

// Application-centric Resource Groups
@export()
var rgName = {
  aiFoundry: 'aiFoundry'
  apim: 'apim'
  app: 'app'
  monitoring: 'monitoring'
  network: 'network'
  shared: 'shared'
}

// Defined subnets in the virtual network
@export()
var subnetName = {
  app: 'app'
  apim: 'apim'
  agents: 'agents'
  containerApps: 'aca'
  privateEndpoints: 'privateEndpoints'
  shared: 'shared'
}

// Shared NSG Rules for all NSGs for inbound rules
@export()
var sharedNSGrulesInbound = []

// Shared NSG Rules for all NSGs for outbound rules
@export()
var sharedNSGrulesOutbound = []

// Shared routes for all Route Tables
@export()
var sharedRoutes = []

// Azure Private DNS Zone Array for isolated deployments
@export()
var privateDnsZoneArray = [
  'privatelink.openai.azure.com'
  'privatelink.vaultcore.azure.net'
  'privatelink.documents.azure.com'
  #disable-next-line no-hardcoded-env-urls
  'privatelink.blob.core.windows.net'
  #disable-next-line no-hardcoded-env-urls
  'privatelink.file.core.windows.net'
  #disable-next-line no-hardcoded-env-urls
  'privatelink.services.ai.azure.com'
  'privatelink.search.windows.net'
  'privatelink.azurecr.io'
  'privatelink.cognitiveservices.azure.com'
  'privatelink.azconfig.io'
]
