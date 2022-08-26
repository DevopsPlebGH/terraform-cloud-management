#!/bin/bash
REPO="DevopsPlebGH/terraform-cloud-management"
BASEURI="https://api.github.com"
ARTIFACTURI="${BASEURI}/repos/${REPO}/actions/artifacts"
TOKEN="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"
ENCRYPTION_KEY="7NQbET89OV@8yCnQQzz20EGgACw#0V"

get_artifacts () {
  curl \
    -w "%{http_code}" \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: token ${TOKEN}" \
    $ARTIFACTURI
}

backend_config () {
  cat <<'EOF'>> tfbackend.tf
resource "local_file" "backend" {
  depends_on = [
    module.organization,
    module.oauth_client
  ]
  content  = <<-EOT
  workspaces { name = "tfc-org-${module.organization.tfe_organization_id}}
  hostname = "app.terraform.io"
  organization = "${module.organization.tfe_organization_id}"
  EOT
  filename = "${path.module}/config.remote.tfbackend"
}
EOF
}

response=$(get_artifacts)
http_code=$(tail -n1 <<< "$response")
content=$(sed '$d' <<< "$response")
most_recent_artifact_uri=$content | jq '[.artifacts[] | select(.name == "terraformstatefile" and .expired == false) | .archive_download_url][0]'

if [[ $http_code -eq 200 ]]; then

  most_recent_artifact_uri=$(echo "$content" | jq '[.artifacts[] | select(.name == "terraformstatefile" and .expired == false) | .archive_download_url][0]')

  echo "Most recent artifact URI is: " $most_recent_artifact_uri | tr -d '"'

  curl \
  -H "Authorization: token ${TOKEN}" \
  -H "Accept: application/vnd.github.v3.raw" \
  -L $(echo "$most_recent_artifact_uri" | tr -d '"') \
  -o ./state.zip

  unzip ./state.zip

  openssl enc -d -in ./terraform.tfstate.enc -aes-256-cbc -pbkdf2 -pass pass:"${ENCRYPTION_KEY}" -out ./terraform.tfstate

  backend_config


else
  echo "fail"
  exit 0
fi



