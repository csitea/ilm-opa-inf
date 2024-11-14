# ORG, APP and PROJ in github actions secrets

# Public ssh key for opening kdbx database
locals {
  file_content_ssh_key_pub = file(pathexpand("~/.ssh/.${var.org}/${var.crs_key_file_name}"))
}

resource "github_actions_secret" "ssh_key_pub_wui" {
  repository      = "${var.org}-${var.app}-wui"
  secret_name     = "SSH_KEY_${upper(var.org)}_${upper(var.app)}_PUB"
  plaintext_value = local.file_content_ssh_key_pub
}

resource "github_actions_secret" "ssh_key_pub_inf" {
  repository      = "${var.org}-${var.app}-inf"
  secret_name     = "SSH_KEY_${upper(var.org)}_${upper(var.app)}_PUB"
  plaintext_value = local.file_content_ssh_key_pub
}
