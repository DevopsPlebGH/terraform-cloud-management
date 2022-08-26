output "organization_id" {
  value = module.organization.tfe_organization_id
}

output "oauth_token_id" {
  value = module.oauth_client.oauth_token_id
}
