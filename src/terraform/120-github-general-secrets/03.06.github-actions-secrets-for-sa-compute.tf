#
# Check if the service account key files exist
# the vm creation steps creates this file hence the condition is required !!!
locals {
  file_sa_compute_content_prd = fileexists(pathexpand("~/.gcp/.${var.org}/key-${var.org}-${var.app}-prd.json")) ? file(pathexpand("~/.gcp/.${var.org}/key-${var.org}-${var.app}-prd.json")) : ""
  file_sa_compute_content_dev = fileexists(pathexpand("~/.gcp/.${var.org}/key-${var.org}-${var.app}-dev.json")) ? file(pathexpand("~/.gcp/.${var.org}/key-${var.org}-${var.app}-dev.json")) : ""
  file_sa_compute_content_tst = fileexists(pathexpand("~/.gcp/.${var.org}/key-${var.org}-${var.app}-tst.json")) ? file(pathexpand("~/.gcp/.${var.org}/key-${var.org}-${var.app}-tst.json")) : ""
}

# Add the secrets for the service account compute key if the file exists
resource "github_actions_secret" "gcp_service_account_key_prd_for_compute" {
  count            = local.file_sa_compute_content_prd != "" ? 1 : 0
  repository       = "${var.org}-${var.app}-wui"
  secret_name      = "GCP_KEY_${upper(var.org)}_${upper(var.app)}_PRD_COMPUTE"
  plaintext_value  = local.file_sa_compute_content_prd
}

resource "github_actions_secret" "gcp_service_account_key_dev_for_compute" {
  count            = local.file_sa_compute_content_dev != "" ? 1 : 0
  repository       = "${var.org}-${var.app}-wui"
  secret_name      = "GCP_KEY_${upper(var.org)}_${upper(var.app)}_DEV_COMPUTE"
  plaintext_value  = local.file_sa_compute_content_dev
}

resource "github_actions_secret" "gcp_service_account_key_tst_for_compute" {
  count            = local.file_sa_compute_content_tst != "" ? 1 : 0
  repository       = "${var.org}-${var.app}-wui"
  secret_name      = "GCP_KEY_${upper(var.org)}_${upper(var.app)}_TST_COMPUTE"
  plaintext_value  = local.file_sa_compute_content_tst
}
