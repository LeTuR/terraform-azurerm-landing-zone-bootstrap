resource "github_repository" "this" {
  name                 = var.repository_name
  description          = var.repository_name
  auto_init            = true
  visibility           = local.repo_visibility
  allow_update_branch  = true
  allow_merge_commit   = false
  allow_rebase_merge   = false
  allow_squash_merge   = true
  vulnerability_alerts = true
}

resource "github_repository_file" "this" {
  for_each = local.pipeline_files

  repository          = github_repository.this.name
  file                = each.key
  content             = each.value.content
  commit_author       = local.default_commit_email
  commit_email        = local.default_commit_email
  commit_message      = "Add ${each.key} [skip ci]"
  overwrite_on_create = true
}

resource "github_branch_protection" "this" {
  count      = local.activated_features.deployment_protection_rule ? 1 : 0
  depends_on = [github_repository.this]

  repository_id                   = github_repository.this.name
  pattern                         = "main"
  enforce_admins                  = true
  required_linear_history         = true
  require_conversation_resolution = true
  require_signed_commits          = var.require_signed_commits

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    restrict_dismissals             = true
    required_approving_review_count = length(var.approvers) > 1 ? 1 : 0
  }
}
