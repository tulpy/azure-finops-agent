param location string
@secure()
param resourceToken string
param tags object

module workspace 'br/public:avm/res/operational-insights/workspace:0.16.1' = {
  params: {
    // Required parameters
    name: 'log-finops-${resourceToken}'
    // Non-required parameters
    skuName: 'PerGB2018'
    dataRetention: 30
    location: location
    tags: tags
  }
}

module component 'br/public:avm/res/insights/component:0.8.0' = {
  params: {
    // Required parameters
    name: 'appi-finops-${resourceToken}'
    workspaceResourceId: workspace.outputs.resourceId
    // Non-required parameters
    disableLocalAuth: true
    ingestionMode: 'LogAnalytics'
    kind: 'web'
    location: location
    tags: tags
  }
}


output logAnalyticsWorkspaceId string = workspace.outputs.resourceId
output appInsightsConnectionString string = component.outputs.connectionString
