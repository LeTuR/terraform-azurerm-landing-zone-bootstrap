locals {
  resource_names = module.resource_names.resource_names
}

locals {
  tenant_id = data.azurerm_client_config.current.tenant_id
}

locals {
  plan_key  = "plan"
  apply_key = "apply"
}

locals {
  team_name = local.resource_names.version_control_system_team
  environments = {
    (local.plan_key)  = local.resource_names.version_control_system_environment_plan,
    (local.apply_key) = local.resource_names.version_control_system_environment_apply,
  }
}

locals {
  role_definitions = {
    owner = {
      name = "Owner"
    }
    reader = {
      name = "Reader"
    }
    storage_owner = {
      name = "Storage Blob Data Owner"
    }
    storage_reader = {
      name = "Storage Blob Data Reader"
    }
  }

  user_assigned_managed_identities = {
    (local.plan_key)  = local.resource_names.identity_plan_name
    (local.apply_key) = local.resource_names.identity_apply_name
  }

  federated_credentials = {
    for key in [local.plan_key, local.apply_key] : key => {
      federated_credential_name          = "${local.resource_names.user_assigned_managed_identity_federated_credentials_prefix}-${key}"
      federated_credential_issuer        = module.github[0].issuer
      user_assigned_managed_identity_key = key
      federated_credential_subject       = module.github[0].subjects[key]
    }
  }

  managed_identity_client_ids = {
    (local.plan_key)  = module.azure.managed_identity_client_ids[local.plan_key]
    (local.apply_key) = module.azure.managed_identity_client_ids[local.apply_key]
  }

  role_assignments_for_landing_zone = {
    (local.plan_key) = {
      role_definition                  = "reader"
      user_assigned_managed_identities = [local.plan_key]
    }
    (local.apply_key) = {
      role_definition                  = "owner"
      user_assigned_managed_identities = [local.apply_key]
    }
  }

  role_assignments_for_landing_zone_state = {
    (local.plan_key) = {
      role_definition                  = "storage_owner"
      user_assigned_managed_identities = [local.plan_key]
    }
    (local.apply_key) = {
      role_definition                  = "storage_owner"
      user_assigned_managed_identities = [local.apply_key]
    }
  }
}
