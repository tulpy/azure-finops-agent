param location string
@secure()
param resourceToken string
param tags object

resource workspace 'Microsoft.OperationalInsights/workspaces@2025-07-01' = {
  name: 'log-finops-${resourceToken}'
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}

module component 'br/public:avm/res/insights/component:0.8.0' = {
  params: {
    // Required parameters
    name: 'appi-finops-${resourceToken}'
    workspaceResourceId: workspace.id
    // Non-required parameters
    ingestionMode: 'LogAnalytics'
    kind: 'web'
    location: location
    tags: tags
  }
}


output logAnalyticsWorkspaceId string = workspace.id
output appInsightsConnectionString string = component.outputs.connectionString
