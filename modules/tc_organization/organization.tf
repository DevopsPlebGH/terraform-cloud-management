module "organization" {
  source  = "BrynardSecurity-terraform/tc-organization/tfe"
  version = "0.1.7"
  # insert the 2 required variables here
  admin_email = var.admin_email
  name        = var.name
}
