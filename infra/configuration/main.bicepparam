using '../main.bicep'

param environmentName = 'sbx'
param location = 'australiaeast'
param resourceGroupName = 'rg-aue-ai-prd-finopsagent'
param logAnalyticsConfiguration = {
  name: 'law-aue-ai-prd-finopsagent'
  skuName: 'PerGB2018'
  dataRetention: 30
}

param applicationInsightsConfiguration = {
  name: 'aai-aue-ai-prd-finopsagent'
  disableLocalAuth: true
  ingestionMode: 'LogAnalytics'
  kind: 'web'
}

param cognitiveServicesConfiguration = {
  name: 'aoai-aue-ai-prd-finopsagent'
  location: 'australiaeast'
  kind: 'AIServices'
  sku: 'S0'
  allowProjectManagement: true
  customSubDomainName: 'aoai-aue-ai-prd-finopsagent'
  publicNetworkAccess: 'Enabled'
  disableLocalAuth: true
  deployments: [
    {
      name: 'gpt-5.6-sol'
      model: {
        name: 'gpt-5.6-sol'
        format: 'OpenAI'
        version: '2026-07-09'
      }
      sku: {
        name: 'GlobalStandard'
        capacity: 100
      }
    }
  ]
}

param cognitiveServicesProjectConfiguration = {
  name: 'finOpsAgent'
  displayName: 'FinOps Agent'
  description: 'Project for the FinOps Agent deployment.'
}

param containerRegistryConfiguration = {
name: 'acrauedaiprdfinopsagent'
acrAdminUserEnabled: false
sku: 'Basic'
anonymousPullEnabled: false
}
