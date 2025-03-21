resource "random_string" "this" {
  length  = 6
  special = false
  upper   = false
}

module "resource_names" {
  source = "./modules/resource_names"

  postfix_number   = var.postfix_number
  azure_location   = var.location
  environment_name = var.environment_name
  service_name     = var.service_name
  resource_names   = var.resource_names
}

module "github" {
  source = "./modules/github"

  count = var.version_control_server == "github" ? 1 : 0

  service_name                                 = var.service_name
  environment_name                             = var.environment_name
  organization_name                            = var.github_organization_name
  repository_name                              = local.resource_names.version_control_system_repository_infra
  repository_exists                            = var.github_repository_exists
  approvers                                    = var.github_approvers
  team_name                                    = local.team_name
  require_signed_commits                       = var.github_require_signed_commits
  environments                                 = local.environments
  private_repository                           = var.github_private_repository
  azure_tenant_id                              = local.tenant_id
  azure_subscription_id                        = var.landing_zone_subscription_id
  backend_azure_resource_group_name            = module.azure.backend_azure_resource_group_name
  backend_azure_storage_account_name           = module.azure.backend_azure_storage_account_name
  backend_azure_storage_account_container_name = module.azure.backend_azure_storage_account_container_name
  managed_identity_client_ids                  = local.managed_identity_client_ids
  root_module_folder_relative_path             = var.github_root_module_folder_relative_path
}

module "azure" {
  source = "./modules/azure"

  location                                = var.location
  subscription_id                         = var.landing_zone_subscription_id
  resource_group_state_name               = local.resource_names.resource_group_state_name
  resource_group_identity_name            = local.resource_names.resource_group_identity_name
  storage_account_name                    = local.resource_names.storage_account_state_name
  user_assigned_managed_identities        = local.user_assigned_managed_identities
  role_assignments_for_landing_zone       = local.role_assignments_for_landing_zone
  role_assignments_for_landing_zone_state = local.role_assignments_for_landing_zone_state
  role_definitions                        = local.role_definitions
  federated_credentials                   = local.federated_credentials
  enable_telemetry                        = var.enable_telemetry
}
