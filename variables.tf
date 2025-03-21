variable "service_name" {
  description = "The name of the landing zone service."
  type        = string
}

variable "environment_name" {
  description = "The name of the environment."
  type        = string
}

variable "postfix_number" {
  description = "Used to build up the default resource names (e.g. rg-terraform-dev-francecentral-<postfix_number>)"
  type        = number
  default     = 1
}

variable "location" {
  description = "The location/region where the resources will be created."
  type        = string
}

variable "version_control_server" {
  description = "The version control system server."
  type        = string
  default     = "github"
  validation {
    condition     = can(regex("^(github|gitlab)$", var.version_control_server))
    error_message = "The version control system server must be either 'github' or 'gitlab'."
  }
}

variable "github_repository_exists" {
  description = "Set to true if the repository already exists."
  type        = bool
  default     = false
}

variable "github_personal_access_token" {
  description = "The personal access token for GitHub."
  type        = string
  sensitive   = true
  default     = ""
}

variable "github_organization_name" {
  description = "The name of your GitHub organization. This is the section of the url after 'github.com'. E.g. enter 'my-org' for 'https://github.com/my-org'"
  type        = string
  default     = ""
}

variable "github_approvers" {
  description = "The list of GitHub users or teams that can approve the apply workflow."
  type        = list(string)
  default     = []
}

variable "github_private_repository" {
  description = "Set GitHub private repository. When using a free plan, public repositories are required to get all the deployment features such as deployment protection rules and environments."
  type        = bool
  default     = true
}

variable "github_require_signed_commits" {
  description = "Enforce signed commits for security"
  type        = bool
  default     = true
}

variable "github_root_module_folder_relative_path" {
  description = "Set root module folder"
  type        = string
  default     = "."
}

variable "landing_zone_subscription_id" {
  description = "The subscription id of the landing zone."
  type        = string
  default     = ""
}

variable "enable_telemetry" {
  description = "Enable telemetry."
  type        = bool
  default     = true
}
