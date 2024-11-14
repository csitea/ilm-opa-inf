# GCP service account keys
locals {
  file_admin_content_prd     = file(pathexpand("~/.gcp/.${var.org}/key-${var.org}-${var.app}-prd.json"))
  file_admin_content_dev     = file(pathexpand("~/.gcp/.${var.org}/key-${var.org}-${var.app}-dev.json"))
  file_admin_content_tst     = file(pathexpand("~/.gcp/.${var.org}/key-${var.org}-${var.app}-tst.json"))
  escaped_content_prd  = replace(local.file_admin_content_prd, "\"", "\\\"")
  escaped_content_dev  = replace(local.file_admin_content_dev, "\"", "\\\"")
  escaped_content_tst  = replace(local.file_admin_content_tst, "\"", "\\\"")

  # the service account keys for the compute service account
}



resource "github_actions_secret" "gcp_service_account_key_prd_for_admin" {
  repository      = "${var.org}-${var.app}-wui"
  secret_name     = "GCP_KEY_${upper(var.org)}_${upper(var.app)}_PRD"
  plaintext_value = local.escaped_content_prd
}

resource "github_actions_secret" "gcp_service_account_key_dev_for_admin" {
  repository      = "${var.org}-${var.app}-wui"
  secret_name     = "GCP_KEY_${upper(var.org)}_${upper(var.app)}_DEV"
  plaintext_value = local.escaped_content_dev
}

resource "github_actions_secret" "gcp_service_account_key_tst_for_admin" {
  repository      = "${var.org}-${var.app}-wui"
  secret_name     = "GCP_KEY_${upper(var.org)}_${upper(var.app)}_TST"
  plaintext_value = local.escaped_content_tst
}


