module "oauth_client" {
  source  = "BrynardSecurity-terraform/tc-organization/tfe//modules/tfe_oauth_client"
  version = "0.1.7"
  # insert the 5 required variables here
  api_url               = var.api_url
  https_url             = var.https_url
  oauth_token           = var.oauth_token
  organization          = module.organization.tfe_organization_id
  service_provider      = var.service_provider
  tfe_oauth_client_name = module.organization.tfe_organization_id
}
