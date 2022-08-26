module "organization" {
  source  = "BrynardSecurity-terraform/tc-organization/tfe"
  version = "0.1.7"
  # insert the 2 required variables here
  admin_email = var.admin_email
  name        = var.name
}

#resource "local_file" "backend" {
#  depends_on = [
#    module.organization,
#    module.oauth_client
#  ]
#  content  = <<-EOT
#  workspaces { name = "tfc-org-${module.organization.tfe_organization_id}}
#  hostname = "app.terraform.io"
#  organization = "${module.organization.tfe_organization_id}"
#  EOT
#  filename = "${path.module}/config.remote.tfbackend"
#}
