// Workload User Defined Types for Azure Services https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/user-defined-data-types
import * as commonTypes from 'br/public:avm/utl/types/avm-common-types:0.6.1' // Common Types including Locks, Managed Identities, Role Assignments, etc.

///////////////////////////////////////////////

// 1.0 Workload Landing Zone Types
// 1.1 Azure Virtual Machine Type
// 1.2 Azure Recovery Services Vault Type
// 1.3 Azure Container Registry Type
// 1.4 Azure Search Service Type
// 1.5 Cognitive Service Type
// 1.6 Azure Cosmos DB Type
// 1.7 Cognitive Services Project Type
// 1.8 Azure App Container Environment Type
// 1.9 Azure Front Door Type
// 1.10 Azure API Management Type
// 1.11 Application Insights Type
// 1.12 Bing Search Type
// 1.13 Log Analytics Workspace Type
// 1.14 Front Door WAF Policy Type
// 1.15 EventHub Type

///////////////////////////////////////////////

// 1.0 Workload Landing Zone Types
// 1.1 Azure Virtual Machine Type
import {
  nicConfigurationType
  imageReferenceType
  planType
  osDiskType
  dataDiskType
} from 'br/public:avm/res/compute/virtual-machine:0.20.0'
@export()
@description('The type for Azure Virtual Machine configuration.')
type virtualMachineType = {
  @maxLength(15)
  @description('Required. The name of the virtual machine to be created. You should use a unique prefix to reduce name collisions in Active Directory.')
  name: string

  @description('Required. If set to 1, 2 or 3, the availability zone is hardcoded to that value. If set to -1, no zone is defined. Note that the availability zone numbers here are the logical availability zone in your Azure subscription. Different subscriptions might have a different mapping of the physical zone and logical zone. To understand more, please refer to [Physical and logical availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview?tabs=azure-cli#physical-and-logical-availability-zones).')
  availabilityZone: (-1 | 1 | 2 | 3)

  @description('Required. Specifies the size for the VMs.')
  vmSize: string

  @description('Conditional. The username for the administrator account on the virtual machine. Required if a virtual machine is created as part of the module.')
  adminUsername: string

  @description('Conditional. The password for the administrator account on the virtual machine. Required if a virtual machine is created as part of the module.')
  @secure()
  adminPassword: string?

  @description('Required. Configures NICs and PIPs.')
  nicConfigurations: nicConfigurationType[]
  @description('Optional. This property can be used by user in the request to enable or disable the Host Encryption for the virtual machine. This will enable the encryption for all the disks including Resource/Temp disk at host itself. For security reasons, it is recommended to set encryptionAtHost to \'true\'.')
  encryptionAtHost: bool?

  @description('Optional. Specifies the SecurityType of the virtual machine. It has to be set to any specified value to enable UefiSettings. The default behavior is: UefiSettings will not be enabled unless this property is set.')
  securityType: 'confidentialVM' | 'trustedLaunch' | ''?

  @description('Optional. Specifies whether secure boot should be enabled on the virtual machine. This parameter is part of the UefiSettings. SecurityType should be set to TrustedLaunch to enable UefiSettings.')
  secureBootEnabled: bool?

  @description('Optional. Specifies whether vTPM should be enabled on the virtual machine. This parameter is part of the UefiSettings.  SecurityType should be set to TrustedLaunch to enable UefiSettings.')
  vTpmEnabled: bool?

  @description('Required. OS image reference. In case of marketplace images, it\'s the combination of the publisher, offer, sku, version attributes. In case of custom images it\'s the resource ID of the custom image.')
  imageReference: imageReferenceType

  @description('Optional. Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use.')
  plan: planType?

  @description('Required. Specifies the OS disk. For security reasons, it is recommended to specify DiskEncryptionSet into the osDisk object.  Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.')
  osDisk: osDiskType

  @description('Optional. Specifies the data disks. For security reasons, it is recommended to specify DiskEncryptionSet into the dataDisk object. Restrictions: DiskEncryptionSet cannot be enabled if Azure Disk Encryption (guest-VM encryption using bitlocker/DM-Crypt) is enabled on your VMs.')
  dataDisks: dataDiskType[]?

  @description('Optional. Specifies that the image or disk that is being used was licensed on-premises.')
  licenseType: ('RHEL_BYOS' | 'SLES_BYOS' | 'Windows_Client' | 'Windows_Server')?

  @description('Optional. VM guest patching orchestration mode. Refer to \'https://learn.microsoft.com/en-us/azure/virtual-machines/automatic-vm-guest-patching\'.')
  patchMode: 'AutomaticByPlatform' | 'AutomaticByOS' | 'Manual'?

  @description('Optional. Whether to enable the Microsoft.Azure.ActiveDirectory AADLoginForWindows extension, allowing users to log in to the virtual machine using Microsoft Entra. Defaults to \'false\'.')
  enableAadLoginExtension: bool?

  @description('Optional. Whether to enable the Microsoft.Azure.Monitor AzureMonitorWindowsAgent extension. Defaults to \'false\'.')
  enableAzureMonitorAgent: bool?

  @description('Optional. The resource Id of a maintenance configuration for the virtual machine.')
  maintenanceConfigurationResourceId: string?

  @description('Optional. Tags of the resource.')
  tags: resourceInput<'Microsoft.Compute/virtualMachines@2024-11-01'>.tags?

  @description('Optional. The lock settings of the service.')
  lock: commonTypes.lockType?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: commonTypes.roleAssignmentType[]?
}

// 1.2 Azure Recovery Services Vault Type
import {
  backupPolicyType
  backupConfigType
  protectedItemType
  replicationFabricType
  replicationPolicyType
  replicationAlertSettingsType
  monitoringSettingsType
  softDeleteSettingType
  redundancySettingsType
  restoreSettingsType
} from 'br/public:avm/res/recovery-services/vault:0.10.1'
@export()
@description('The type for Azure Recovery Services Vault configuration.')
type recoveryVaultType = {
  @description('Optional. Name of the Azure Recovery Service Vault.')
  name: string?

  @description('Optional. List of all backup policies.')
  backupPolicies: backupPolicyType[]?

  @description('Optional. The backup configuration.')
  backupConfig: backupConfigType?

  @description('Optional. List of all protection containers.')
  protectedItems: protectedItemType[]?

  @description('Optional. List of all replication fabrics.')
  replicationFabrics: replicationFabricType[]?

  @description('Optional. List of all replication policies.')
  replicationPolicies: replicationPolicyType[]?

  @description('Optional. Replication alert settings.')
  replicationAlertSettings: replicationAlertSettingsType?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: commonTypes.roleAssignmentType[]?

  @description('Optional. The lock settings of the service.')
  lock: commonTypes.lockType?

  @description('Optional. Tags of the Recovery Service Vault resource.')
  tags: resourceInput<'Microsoft.RecoveryServices/vaults@2024-04-01'>.tags?

  @description('Optional. Monitoring Settings of the vault.')
  monitoringSettings: monitoringSettingsType?

  @description('Optional. The soft delete related settings.')
  softDeleteSettings: softDeleteSettingType?

  @description('Optional. The immmutability setting state of the recovery services vault resource.')
  immutabilitySettingState: 'Disabled' | 'Locked' | 'Unlocked'?

  @description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled.')
  publicNetworkAccess: 'Disabled' | 'Enabled'?

  @description('Optional. The redundancy settings of the vault.')
  redundancySettings: redundancySettingsType?

  @description('Optional. The restore settings of the vault.')
  restoreSettings: restoreSettingsType?
}

// 1.3 Azure Container Registry Type
import { scopeMapsType, cacheRuleType, credentialSetType, replicationType, webhookType } from 'br/public:avm/res/container-registry/registry:0.9.1'
@export()
@description('The type for Azure Container Registry configuration.')
type containerRegistryType = {
  @minLength(5)
  @maxLength(50)
  @description('Optional. The name of the container registry, Container registry names must be globally unique.')
  name: string?

  @description('Optional. Whether the trust policy is enabled for the container registry. Defaults to \'enabled\'.')
  trustPolicyStatus: 'enabled' | 'disabled'?

  @description('Optional. Tier of your Azure container registry.')
  sku: 'Basic' | 'Standard' | 'Premium'?

  @description('Optional. This value can be set to \'Enabled\' to avoid breaking changes on existing customer resources and templates. If set to \'Disabled\', traffic over public interface is not allowed, and private endpoint connections would be the exclusive access method.')
  publicNetworkAccess: 'Enabled' | 'Disabled'?

  @description('Optional. Soft Delete policy status. Default is disabled.')
  softDeletePolicyStatus: 'disabled' | 'enabled'?

  @description('Optional. The number of days after which a soft-deleted item is permanently deleted.')
  softDeletePolicyDays: int?

  @description('Optional. Enable admin user that have push / pull permission to the registry.')
  acrAdminUserEnabled: bool?

  @description('Optional. The value that indicates whether the export policy is enabled or not.')
  exportPolicyStatus: 'disabled' | 'enabled'?

  @description('Optional. Whether or not zone redundancy is enabled for this container registry.')
  zoneRedundancy: 'Disabled' | 'Enabled'?

  @description('Optional. Whether to allow trusted Azure services to access a network restricted registry.')
  networkRuleBypassOptions: 'AzureServices' | 'None'?

  @description('Optional. The default action of allow or deny when no other rules match.')
  networkRuleSetDefaultAction: 'Allow' | 'Deny'?

  @description('Optional. The IP ACL rules. Note, requires the \'acrSku\' to be \'Premium\'.')
  networkRuleSetIpRules: array?

  @description('Optional. Enables registry-wide pull from unauthenticated clients. It\'s in preview and available in the Standard and Premium service tiers.')
  anonymousPullEnabled: bool?

  @description('Optional. Scope maps setting.')
  scopeMaps: scopeMapsType[]?

  @description('Optional. Array of Cache Rules.')
  cacheRules: cacheRuleType[]?

  @description('Optional. Array of Credential Sets.')
  credentialSets: credentialSetType[]?

  @description('Optional. All replications to create.')
  replications: replicationType[]?

  @description('Optional. All webhooks to create.')
  webhooks: webhookType[]?

  @description('Optional. Tags of the resource.')
  tags: resourceInput<'Microsoft.ContainerRegistry/registries@2025-04-01'>.tags?

  @description('Optional. The lock settings of the service.')
  lock: commonTypes.lockType?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: commonTypes.roleAssignmentType[]?
}

// 1.4 Azure Search Service Type
import {
  networkRuleSetType as azureSearchNetworkRuleSetType
} from 'br/public:avm/res/search/search-service:0.10.0'
@export()
@description('The type for Azure Search Service configuration.')
type searchServiceType = {
  @minLength(1)
  @maxLength(60)
  @description('Optional. The name of the Azure Search Service.')
  name: string?

  @description('Optional. Whether or not to enable semantic search. If not specified, it will be disabled by default.')
  semanticSearch: 'standard' | 'free' | 'disabled'

  @description('Optional. Defines the SKU of an Azure Cognitive Search Service, which determines price tier and capacity limits.')
  sku:
    | 'standard'
    | 'basic'
    | 'free'
    | 'standard'
    | 'standard2'
    | 'standard3'
    | 'storage_optimized_l1'
    | 'storage_optimized_l2'

  @description('Optional. Applicable only for the standard3 SKU. You can set this property to enable up to 3 high density partitions that allow up to 1000 indexes, which is much higher than the maximum indexes allowed for any other SKU. For the standard3 SKU, the value is either \'default\' or \'highDensity\'. For all other SKUs, this value must be \'default\'.')
  hostingMode: 'default' | 'highDensity'

  @description('Optional. This value can be set to \'Enabled\' to avoid breaking changes on existing customer resources and templates. If set to \'Disabled\', traffic over public interface is not allowed, and private endpoint connections would be the exclusive access method.')
  publicNetworkAccess: 'Enabled' | 'Disabled'

  @minValue(1)
  @maxValue(12)
  @description('Optional. The number of replicas in the search service. If specified, it must be a value between 1 and 12 inclusive for standard SKUs or between 1 and 3 inclusive for basic SKU.')
  replicaCount: int?

  @minValue(1)
  @maxValue(12)
  @description('Optional. The number of partitions in the search service; if specified, it can be 1, 2, 3, 4, 6, or 12. Values greater than 1 are only valid for standard SKUs. For \'standard3\' services with hostingMode set to \'highDensity\', the allowed values are between 1 and 3.')
  partitionCount: int?

  @description('Optional. Network specific rules that determine how the Azure Cognitive Search service may be reached.')
  networkRuleSet: azureSearchNetworkRuleSetType?

  @description('Optional. Tags to help categorize the resource in the Azure portal.')
  tags: resourceInput<'Microsoft.Search/searchServices@2025-02-01-preview'>.tags?

  @description('Optional. The lock settings of the service.')
  lock: commonTypes.lockType?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: commonTypes.roleAssignmentType[]?
}

// 1.5  Cognitive Service Type
import {
  deploymentType
  commitmentPlanType
  secretsExportConfigurationType as cognitiveSecretsExportConfigurationType
  networkInjectionType
} from 'br/public:avm/res/cognitive-services/account:0.13.2'
@export()
@description('The type for Azure Cognitive Service configuration.')
type cognitiveServiceType = {
  @minLength(1)
  @maxLength(60)
  @description('Optional. The name of the Cognitive Service Account.')
  name: string?

  @description('Optional. Location for all Resources.')
  location: string?

  @description('Required. Kind of the Cognitive Services. Use \'Get-AzCognitiveServicesAccountSku\' to determine a valid combinations of \'kind\' and \'SKU\' for your Azure region.')
  kind:
    | 'AIServices'
    | 'AnomalyDetector'
    | 'CognitiveServices'
    | 'ComputerVision'
    | 'ContentModerator'
    | 'ContentSafety'
    | 'ConversationalLanguageUnderstanding'
    | 'CustomVision.Prediction'
    | 'CustomVision.Training'
    | 'Face'
    | 'FormRecognizer'
    | 'HealthInsights'
    | 'ImmersiveReader'
    | 'Internal.AllInOne'
    | 'LUIS'
    | 'LUIS.Authoring'
    | 'LanguageAuthoring'
    | 'MetricsAdvisor'
    | 'OpenAI'
    | 'Personalizer'
    | 'QnAMaker.v2'
    | 'SpeechServices'
    | 'TextAnalytics'
    | 'TextTranslation'

  @description('Optional. SKU of the AI Foundry / Cognitive Services account. Use \'Get-AzCognitiveServicesAccountSku\' to determine a valid combinations of \'kind\' and \'SKU\' for your Azure region.')
  sku:
    | 'C2'
    | 'C3'
    | 'C4'
    | 'F0'
    | 'F1'
    | 'S'
    | 'S0'
    | 'S1'
    | 'S10'
    | 'S2'
    | 'S3'
    | 'S4'
    | 'S5'
    | 'S6'
    | 'S7'
    | 'S8'
    | 'S9'
    | 'DC0'

  @description('Optional. Whether to create Capability Hosts for the AI Agent Service. If true, the AI Foundry Account and default Project will be created with the capability host for the associated resources. Can only be true if \'includeAssociatedResources\' is true. Defaults to false.')
  createCapabilityHosts: bool?

  @description('Optional. This value can be set to \'Enabled\' to avoid breaking changes on existing customer resources and templates. If set to \'Disabled\', traffic over public interface is not allowed, and private endpoint connections would be the exclusive access method.')
  publicNetworkAccess: ('Enabled' | 'Disabled')?

  @description('Conditional. Subdomain name used for token-based authentication. Required if \'networkAcls\' or \'privateEndpoints\' are set.')
  customSubDomainName: string?

  @description('Optional. A collection of rules governing the accessibility from specific network locations.')
  networkAcls: object?

  @description('Optional. Specifies in AI Foundry where virtual network injection occurs to secure scenarios like Agents entirely within a private network.')
  networkInjections: networkInjectionType?

  @description('Optional. List of allowed FQDN.')
  allowedFqdnList: array?

  @description('Optional. The API properties for special APIs.')
  apiProperties: object?

  @description('Optional. Allow only Azure AD authentication. Should be enabled for security reasons.')
  disableLocalAuth: bool?

  @description('Optional. The flag to enable dynamic throttling.')
  dynamicThrottlingEnabled: bool?

  @secure()
  @description('Optional. Resource migration token.')
  migrationToken: string?

  @description('Optional. Restore a soft-deleted cognitive service at deployment time. Will fail if no such soft-deleted resource exists.')
  restore: bool?

  @description('Optional. Restrict outbound network access.')
  restrictOutboundNetworkAccess: bool?

  @description('Optional. The storage accounts for this resource.')
  userOwnedStorage: resourceInput<'Microsoft.CognitiveServices/accounts@2025-04-01-preview'>.properties.userOwnedStorage?

  @description('Optional. Key vault reference and secret settings for the module\'s secrets export.')
  secretsExportConfiguration: cognitiveSecretsExportConfigurationType?

  @description('Optional. Enable/Disable project management feature for AI Foundry.')
  allowProjectManagement: bool?

  @description('Optional. Commitment plans to deploy for the cognitive services account.')
  commitmentPlans: commitmentPlanType[]?

  @description('Optional. Configuration for Open AI Deployments.')
  deployments: deploymentType[]?

  @description('Optional. The lock settings of the service.')
  lock: commonTypes.lockType?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: commonTypes.roleAssignmentType[]?

  @description('Optional. The diagnostic settings of the service.')
  diagnosticSettings: commonTypes.diagnosticSettingFullType[]?
}

// 1.6 Azure Cosmos DB Type
import { sqlDatabaseType } from 'br/public:avm/res/document-db/database-account:0.15.0'
@export()
@description('The type for Azure Cosmos DB configuration.')
type cosmosDBType = {
  @minLength(3)
  @maxLength(44)
  @description('Optional. The name of the Cosmos DB Account, Cosmos DB account names must be globally unique.')
  name: string?

  @description('Optional. Opt-out of local authentication and ensure that only Microsoft Entra can be used exclusively for authentication. Defaults to true.')
  disableLocalAuthentication: bool?

  @description('Optional. Default to true. Disable write operations on metadata resources (databases, containers, throughput) via account keys.')
  disableKeyBasedMetadataWriteAccess: bool?

  @description('Optional. The Azure Blob Container values.')
  sqlDatabases: sqlDatabaseType[]?

  @description('Optional. The lock settings of the service.')
  lock: commonTypes.lockType?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: commonTypes.roleAssignmentType[]?
}

// 1.7 Cognitive Services Project Type
@export()
@description('The type for Cognitive Services Project configuration.')
type cognitiveServicesProjectType = {
  @minLength(2)
  @maxLength(64)
  @description('Required. The name of the Cognitive Services Project.')
  name: string

  @description('Optional. The description of the Cognitive Services Project.')
  description: string?

  @description('Optional. The display name of the Cognitive Services Project.')
  displayName: string?
}

// 1.8 Azure App Container Environment Type
import { appLogsConfigurationType } from 'br/public:avm/res/app/managed-environment:0.11.2'
@export()
@description('The type for Azure App Container Environment configuration.')
type appContainerEnvironmentType = {
  @description('Optional. The name of the Azure App Container Environment to create.')
  name: string?

  @description('Optional. Whether or not this Managed Environment is zone-redundant.')
  zoneRedundant: bool?

  @description('Conditional. Boolean indicating the environment only has an internal load balancer. These environments do not have a public static IP resource. If set to true, then "infrastructureSubnetId" must be provided. Required if zoneRedundant is set to true to make the resource WAF compliant.')
  internal: bool?

  @description('Conditional. Resource ID of a subnet for infrastructure components. This is used to deploy the environment into a virtual network. Must not overlap with any other provided IP ranges. Required if "internal" is set to true. Required if zoneRedundant is set to true to make the resource WAF compliant.')
  infrastructureSubnetId: string?

  @description('Conditional. Workload profiles configured for the Managed Environment. Required if zoneRedundant is set to true to make the resource WAF compliant.')
  workloadProfiles: array?

  @description('Optional. The AppLogsConfiguration for the Managed Environment.')
  appLogsConfiguration: appLogsConfigurationType?

  @description('Optional. Tags of the resource.')
  tags: resourceInput<'Microsoft.App/managedEnvironments@2024-10-02-preview'>.tags?

  @description('Optional. The lock settings of the service.')
  lock: commonTypes.lockType?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: commonTypes.roleAssignmentType[]?
}

// 1.9Azure Front Door Type
@export()
@description('The type for Azure Front Door configuration.')
type frontDoorType = {
  @description('Optional. Deployment flag for Azure Front Door.')
  enabled: bool?

  @minLength(5)
  @maxLength(64)
  @description('Optional. The name of the Azure Front Door instance.')
  name: string?

  @description('Optional. Send and receive timeout on forwarding request to the origin.')
  originResponseTimeoutSeconds: int?

  @description('Optional. The lock settings of the service.')
  lock: commonTypes.lockType?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: commonTypes.roleAssignmentType[]?
}

type originGroup = {
  @description('Required. The name of the origin group.')
  name: string

  @description('Required. Load balancing settings for a backend pool.')
  loadBalancingSettings: loadBalancingSettings?

  @description('Optional. Health probe settings to the origin that is used to determine the health of the origin.')
  healthProbeSettings: healthProbeSettings?

  @description('Optional. Whether to allow session affinity on this host.')
  sessionAffinityState: 'Enabled' | 'Disabled' | null

  @description('Optional. Time in minutes to shift the traffic to the endpoint gradually when an unhealthy endpoint comes healthy or a new endpoint is added. Default is 10 mins.')
  trafficRestorationTimeToHealedOrNewEndpointsInMinutes: int?

  @description('Required. The list of origins within the origin group.')
  origins: origin[]
}

type origin = {
  @description('Required. The name of the origin.')
  name: string

  @description('Required. The address of the origin. Domain names, IPv4 addresses, and IPv6 addresses are supported.This should be unique across all origins in an endpoint.')
  hostName: string

  @description('Optional. Whether to enable health probes to be made against backends defined under backendPools. Health probes can only be disabled if there is a single enabled backend in single enabled backend pool.')
  enabledState: 'Enabled' | 'Disabled' | null

  @description('Optional. Whether to enable certificate name check at origin level.')
  enforceCertificateNameCheck: bool?

  @description('Optional. The value of the HTTP port. Must be between 1 and 65535.')
  httpPort: int?

  @description('Optional. The value of the HTTPS port. Must be between 1 and 65535.')
  httpsPort: int?

  @description('Optional. The host header value sent to the origin with each request. If you leave this blank, the request hostname determines this value. Azure Front Door origins, such as Web Apps, Blob Storage, and Cloud Services require this host header value to match the origin hostname by default. This overrides the host header defined at Endpoint.')
  originHostHeader: string?

  @description('Optional. Priority of origin in given origin group for load balancing. Higher priorities will not be used for load balancing if any lower priority origin is healthy.Must be between 1 and 5.')
  priority: int?

  @description('Optional. Weight of the origin in given origin group for load balancing. Must be between 1 and 1000.')
  weight: int?

  @description('Optional. The properties of the private link resource for private origin.')
  sharedPrivateLinkResource: object?
}

type loadBalancingSettings = {
  @description('Required. Additional latency in milliseconds for probes to the backend. Must be between 0 and 1000.')
  additionalLatencyInMilliseconds: int

  @description('Required. Number of samples to consider for load balancing decisions.')
  sampleSize: int

  @description('Required. Number of samples within the sample window that must be successful to mark the backend as healthy.')
  successfulSamplesRequired: int
}

type healthProbeSettings = {
  @description('Optional. The path relative to the origin that is used to determine the health of the origin.')
  probePath: string?

  @description('Optional. Protocol to use for health probe.')
  probeProtocol: 'Http' | 'Https' | 'NotSet' | null

  @description('Optional. The request type to probe.')
  probeRequestType: 'GET' | 'HEAD' | 'NotSet' | null

  @description('Optional. The number of seconds between health probes.Default is 240sec.')
  probeIntervalInSeconds: int?
}

type afdEndpoint = {
  @description('Required. The name of the AFD Endpoint.')
  name: string

  @description('Optional. The list of routes for this AFD Endpoint.')
  routes: route[]?

  @description('Optional. The tags for the AFD Endpoint.')
  tags: object?

  @description('Optional. The scope of the auto-generated domain name label.')
  autoGeneratedDomainNameLabelScope: 'NoReuse' | 'ResourceGroupReuse' | 'SubscriptionReuse' | 'TenantReuse' | null

  @description('Optional. The state of the AFD Endpoint.')
  enabledState: 'Enabled' | 'Disabled' | null
}

type route = {
  @description('Required. The name of the route.')
  name: string

  @description('Optional. The caching configuration for this route. To disable caching, do not provide a cacheConfiguration object.')
  cacheConfiguration: afdRoutecacheConfiguration?

  @description('Optional. The names of the custom domains.')
  customDomainNames: string[]?

  @description('Optional. Whether to enable use of this rule.')
  enabledState: 'Enabled' | 'Disabled' | null

  @description('Optional. The protocol this rule will use when forwarding traffic to backends.')
  forwardingProtocol: 'HttpOnly' | 'HttpsOnly' | 'MatchRequest' | null

  @description('Optional. Whether to automatically redirect HTTP traffic to HTTPS traffic.')
  httpsRedirect: 'Enabled' | 'Disabled' | null

  @description('Optional. Whether this route will be linked to the default endpoint domain.')
  linkToDefaultDomain: 'Enabled' | 'Disabled' | null

  @description('Required. The name of the origin group.')
  originGroupName: string

  @description('Optional. A directory path on the origin that AzureFrontDoor can use to retrieve content from, e.g. contoso.cloudapp.net/originpath.')
  originPath: string?

  @description('Optional. The route patterns of the rule.')
  patternsToMatch: array?

  @description('Optional. The rule sets of the rule.')
  ruleSets: object[]?

  @description('Optional. The supported protocols of the rule.')
  supportedProtocols: array?
}

type afdRoutecacheConfiguration = {
  @description('Required. Compression settings.')
  compressionSettings: {
    @description('Required. List of content types on which compression applies. The value should be a valid MIME type.')
    contentTypesToCompress: string[]

    @description('Optional. Indicates whether content compression is enabled on AzureFrontDoor. Default value is false. If compression is enabled, content will be served as compressed if user requests for a compressed version. Content won\'t be compressed on AzureFrontDoor when requested content is smaller than 1 byte or larger than 1 MB.')
    iscontentTypeToCompressAll: bool?
  }
  @description('Required. Query parameters to include or exclude (comma separated).')
  queryParameters: string

  @description('Required. Defines how Frontdoor caches requests that include query strings.')
  queryStringCachingBehavior:
    | 'IgnoreQueryString'
    | 'IgnoreSpecifiedQueryStrings'
    | 'IncludeSpecifiedQueryStrings'
    | 'UseQueryString'
}

// 1.10 Azure API Management Type
import {
  additionalLocationType
  apiType
  apiVersionSetType
  authorizationServerType
  backendType
  cacheType
  apiDiagnosticType
  identityProviderType
  loggerType
  namedValueType
  policyType
  portalSettingsType
  productType
  subscriptionType
} from 'br/public:avm/res/api-management/service:0.11.0'
@export()
@description('The type for API Management configuration.')
type apiManagementType = {
  @minLength(1)
  @maxLength(50)
  @description('Required. The name of the API Management service.')
  name: string?

  @description('Optional. List of Certificates that need to be installed in the API Management service. Max supported certificates that can be installed is 10.')
  @maxLength(10)
  certificates: resourceInput<'Microsoft.ApiManagement/service@2024-05-01'>.properties.certificates?

  @description('Optional. Custom properties of the API Management service. Not supported if SKU is Consumption.')
  customProperties: resourceInput<'Microsoft.ApiManagement/service@2024-05-01'>.properties.customProperties?

  @description('Optional. Property only valid for an API Management service deployed in multiple locations. This can be used to disable the gateway in master region.')
  disableGateway: bool?

  @description('Optional. Property only meant to be used for Consumption SKU Service. This enforces a client certificate to be presented on each request to the gateway. This also enables the ability to authenticate the certificate in the policy on the gateway.')
  enableClientCertificate: bool?

  @description('Optional. Custom hostname configuration of the API Management service.')
  hostnameConfigurations: resourceInput<'Microsoft.ApiManagement/service@2024-05-01'>.properties.hostnameConfigurations?

  @description('Optional. Limit control plane API calls to API Management service with version equal to or newer than this value.')
  minApiVersion: string?

  @description('Optional. The notification sender email address for the service.')
  notificationSenderEmail: string?

  @description('Required. The email address of the owner of the service.')
  publisherEmail: string

  @description('Required. The name of the owner of the service.')
  publisherName: string

  @description('Optional. Undelete API Management Service if it was previously soft-deleted. If this flag is specified and set to True all other properties will be ignored.')
  restore: bool?

  @description('Required. The pricing tier of this API Management service.')
  sku: 'Consumption' | 'Developer' | 'Basic' | 'Standard' | 'Premium' | 'StandardV2' | 'BasicV2'

  @description('Optional. The scale units for this API Management service. Required if using Basic, Standard, or Premium skus. For range of capacities for each sku, reference https://azure.microsoft.com/en-us/pricing/details/api-management/.')
  skuCapacity: int?

  @description('Optional. The full resource ID of a subnet in a virtual network to deploy the API Management service in.')
  subnetResourceId: string?

  @description('Optional. Tags of the resource.')
  tags: resourceInput<'Microsoft.ApiManagement/service@2025-05-01'>.tags?

  @description('Optional. The type of VPN in which API Management service needs to be configured in. None (Default Value) means the API Management service is not part of any Virtual Network, External means the API Management deployment is set up inside a Virtual Network having an internet Facing Endpoint, and Internal means that API Management deployment is setup inside a Virtual Network having an Intranet Facing Endpoint only.')
  virtualNetworkType: 'None' | 'External' | 'Internal'?

  @description('Optional. A list of availability zones denoting where the resource needs to come from. Only supported by Premium sku.')
  availabilityZones: [1 | 2 | 3]?

  @description('Optional. APIs.')
  apis: apiType[]?

  @description('Optional. API Version Sets.')
  apiVersionSets: apiVersionSetType[]?

  @description('Optional. Authorization servers.')
  authorizationServers: authorizationServerType[]?

  @description('Optional. Backends.')
  backends: backendType[]?

  @description('Optional. Caches.')
  caches: cacheType[]?

  @description('Optional. API Diagnostics.')
  apiDiagnostics: apiDiagnosticType[]?

  @description('Optional. Identity providers.')
  identityProviders: identityProviderType[]?

  @description('Optional. Loggers.')
  loggers: loggerType[]?

  @description('Optional. Named values.')
  namedValues: namedValueType[]?

  @description('Optional. Policies.')
  policies: policyType[]?

  @description('Optional. Portal settings.')
  portalsettings: portalSettingsType[]?

  @description('Optional. Products.')
  products: productType[]?

  @description('Optional. Subscriptions.')
  subscription: subscriptionType[]?

  @description('Optional. Public Standard SKU IP V4 based IP address to be associated with Virtual Network deployed service in the region. Supported only for Developer and Premium SKU being deployed in Virtual Network.')
  publicIpAddressResourceId: string?

  @description('Optional. Enable the Developer Portal. The developer portal is not supported on the Consumption SKU.')
  enableDeveloperPortal: bool?

  @description('Optional. Additional datacenter locations of the API Management service. Not supported with V2 SKUs.')
  additionalLocations: additionalLocationType[]?

  @description('Optional. The lock settings of the service.')
  lock: commonTypes.lockType?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: commonTypes.roleAssignmentType[]?
}

// 1.11 Application Insights Type
@export()
@description('The type for Application Insights configuration.')
type applicationInsightsType = {
  @minLength(1)
  @maxLength(255)
  @description('Optional. The name of the Application Insights resource.')
  name: string?

  @description('Optional. Application type..')
  applicationType: 'other' | 'web'?

  @description('Optional. The kind of application that this component refers to, used to customize UI. This value is a freeform string, values should typically be one of the following: web, ios, other, store, java, phone.')
  kind: string?

  @description('Optional. Tags of the resource.')
  tags: resourceInput<'Microsoft.Insights/components@2020-10-01'>.tags?

  @description('Optional. Disable IP masking. Default value is set to true.')
  disableIpMasking: bool?

  @description('Optional. Disable Non-AAD based Auth. Default value is set to false.')
  disableLocalAuth: bool?

  @description('Optional. Indicates the flow of the ingestion.')
  ingestionMode: 'ApplicationInsights' | 'ApplicationInsightsWithDiagnosticSettings' | 'LogAnalytics'?

  @description('Optional. The lock settings of the service.')
  lock: commonTypes.lockType?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: commonTypes.roleAssignmentType[]?
}

// 1.12 Bing Search Type
@export()
@description('The type for Bing Search configuration.')
type bingSearchType = {
  @description('Required. The name of the Bing Search resource.')
  name: string?
}

// 1.13 Log Analytics Workspace Type
import {
  storageInsightsConfigType
  linkedServiceType
  linkedStorageAccountType
  savedSearchType
  dataExportType
  dataSourceType
  tableType
  gallerySolutionType
  workspaceFeaturesType
  workspaceReplicationType
} from 'br/public:avm/res/operational-insights/workspace:0.12.0'
@export()
@description('The type for Log Analytics configuration.')
type logAnalyticsType = {
  @minLength(4)
  @maxLength(63)
  @description('Optional. The name of the Log Analytics workspace.')
  name: string?

  @description('Optional. The name of the SKU.')
  skuName: (
    | 'CapacityReservation'
    | 'Free'
    | 'LACluster'
    | 'PerGB2018'
    | 'PerNode'
    | 'Premium'
    | 'Standalone'
    | 'Standard')?

  @minValue(100)
  @maxValue(5000)
  @description('Optional. The capacity reservation level in GB for this workspace, when CapacityReservation sku is selected. Must be in increments of 100 between 100 and 5000.')
  skuCapacityReservationLevel: int?

  @description('Optional. List of storage accounts to be read by the workspace.')
  storageInsightsConfigs: storageInsightsConfigType[]?

  @description('Optional. List of services to be linked.')
  linkedServices: linkedServiceType[]?

  @description('Conditional. List of Storage Accounts to be linked. Required if \'forceCmkForQuery\' is set to \'true\' and \'savedSearches\' is not empty.')
  linkedStorageAccounts: linkedStorageAccountType[]?

  @description('Optional. Kusto Query Language searches to save.')
  savedSearches: savedSearchType[]?

  @description('Optional. LAW data export instances to be deployed.')
  dataExports: dataExportType[]?

  @description('Optional. LAW data sources to configure.')
  dataSources: dataSourceType[]?

  @description('Optional. LAW custom tables to be deployed.')
  tables: tableType[]?

  @description('Optional. List of gallerySolutions to be created in the log analytics workspace.')
  gallerySolutions: gallerySolutionType[]?

  @description('Optional. Onboard the Log Analytics Workspace to Sentinel. Requires \'SecurityInsights\' solution to be in gallerySolutions.')
  onboardWorkspaceToSentinel: bool?

  @description('Optional. Number of days data will be retained for.')
  @minValue(0)
  @maxValue(730)
  dataRetention: int?

  @description('Optional. The workspace daily quota for ingestion.')
  @minValue(-1)
  dailyQuotaGb: int?

  @description('Optional. The network access type for accessing Log Analytics ingestion.')
  publicNetworkAccessForIngestion: ('Enabled' | 'Disabled')?

  @description('Optional. The network access type for accessing Log Analytics query.')
  publicNetworkAccessForQuery: ('Enabled' | 'Disabled')?

  @description('Optional. The workspace features.')
  features: workspaceFeaturesType?

  @description('Optional. The workspace replication properties.')
  replication: workspaceReplicationType?

  @description('Optional. Indicates whether customer managed storage is mandatory for query management.')
  forceCmkForQuery: bool?

  @description('Optional. Tags of the resource.')
  tags: resourceInput<'Microsoft.OperationalInsights/workspaces@2025-02-01'>.tags?

  @description('Optional. The lock settings of the service.')
  lock: commonTypes.lockType?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: commonTypes.roleAssignmentType[]?
}

// 1.14 Front Door WAF Policy Type
import {
  managedRulesType
  customRulesType
} from 'br/public:avm/res/network/front-door-web-application-firewall-policy:0.3.3'
@export()
@description('The type for Log Analytics configuration.')
type frontDoorWAFType = {
  @description('Required. Name of the Front Door WAF policy.')
  @minLength(1)
  @maxLength(128)
  name: string?

  @description('Optional. The pricing tier of the WAF profile.')
  sku: ('Standard_AzureFrontDoor' | 'Premium_AzureFrontDoor')?

  @description('Optional. Resource tags.')
  tags: resourceInput<'Microsoft.Network/FrontDoorWebApplicationFirewallPolicies@2025-03-01'>.tags?

  @description('Optional. Describes the managedRules structure.')
  managedRules: managedRulesType?

  @description('Optional. The custom rules inside the policy.')
  customRules: customRulesType?

  @description('Optional. The PolicySettings for policy.')
  policySettings: object?

  @description('Optional. The lock settings of the service.')
  lock: commonTypes.lockType?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: commonTypes.roleAssignmentType[]?
}

// 1.15 EventHub Type
import {
  networkRuleSetType as eventHubNetworkRuleSetType
  eventHubType
  disasterRecoveryConfigType
  secretsExportConfigurationType
} from 'br/public:avm/res/event-hub/namespace:0.13.0'
@export()
@description('The type for Log Analytics configuration.')
type eventHubNamespaceType = {
  @description('Required. The name of the event hub namespace.')
  @maxLength(50)
  name: string?

  @description('Optional. event hub plan SKU name.')
  skuName: ('Basic' | 'Standard' | 'Premium')?

  @description('Optional. The Event Hubs throughput units for Basic or Standard tiers, where value should be 0 to 20 throughput units. The Event Hubs premium units for Premium tier, where value should be 0 to 10 premium units.')
  @minValue(1)
  @maxValue(20)
  skuCapacity: int?

  @description('Optional. Switch to make the Event Hub Namespace zone redundant.')
  zoneRedundant: bool?

  @description('Optional. Switch to enable the Auto Inflate feature of Event Hub. Auto Inflate is not supported in Premium SKU EventHub.')
  isAutoInflateEnabled: bool?

  @description('Optional. Upper limit of throughput units when AutoInflate is enabled, value should be within 0 to 20 throughput units.')
  @minValue(0)
  @maxValue(20)
  maximumThroughputUnits: int?

  @description('Optional. Authorization Rules for the Event Hub namespace.')
  authorizationRules: array?

  @description('Optional. This property disables SAS authentication for the Event Hubs namespace.')
  disableLocalAuth: bool?

  @description('Optional. Value that indicates whether Kafka is enabled for Event Hubs Namespace.')
  kafkaEnabled: bool?

  @description('Optional. The minimum TLS version for the cluster to support.')
  minimumTlsVersion: ('1.0' | '1.1' | '1.2')?

  @description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.')
  publicNetworkAccess: ('Disabled' | 'Enabled' | 'SecuredByPerimeter')?

  @description('Optional. Configure networking options. This object contains IPs/Subnets to allow or restrict access to private endpoints only. For security reasons, it is recommended to configure this object on the Namespace.')
  networkRuleSets: eventHubNetworkRuleSetType?

  @description('Optional. The lock settings of the service.')
  lock: commonTypes.lockType?

  @description('Optional. Array of role assignments to create.')
  roleAssignments: commonTypes.roleAssignmentType[]?

  @description('Optional. Enable infrastructure encryption (double encryption). Note, this setting requires the configuration of Customer-Managed-Keys (CMK) via the corresponding module parameters.')
  requireInfrastructureEncryption: bool?

  @description('Optional. Tags of the resource.')
  tags: resourceInput<'Microsoft.EventHub/namespaces@2024-01-01'>.tags?

  @description('Optional. The event hubs to deploy into this namespace.')
  eventhubs: eventHubType[]?

  @description('Optional. The disaster recovery config for this namespace.')
  disasterRecoveryConfig: disasterRecoveryConfigType?

  @description('Optional. Key vault reference and secret settings for the module\'s secrets export.')
  secretsExportConfiguration: secretsExportConfigurationType?
}
