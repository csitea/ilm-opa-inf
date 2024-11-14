module "manual_secrets" {
  source = "../modules/gcp-manual-secrets"

    org = var.org
    app = var.app
    env = var.env
    gcp_project = "ilm-opa-all"
    proj_sa_acc_key_secret_id = "${var.org}-${var.app}-${var.env}-proj-sa-acc-key"

  providers = {
    google = google.all
  }
}
