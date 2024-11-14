module "ssh_key" {
  source        = "../modules/ssh-key-v01"

  org           = var.org
  app           = var.app
  env           = var.env
  key_name      = var.host_name
}

resource "google_secret_manager_secret" "ssh_key_vm_skk_debian" {
  secret_id = "ssh-key-${var.org}-${var.app}-${var.env}-skk-debian-vm"

  replication {
    automatic = true // this is not an error dont change it !!!
  }
}

resource "google_secret_manager_secret_version" "ssh_key_vm_skk_debian_secret_version" {
  secret      = google_secret_manager_secret.ssh_key_vm_skk_debian.id
  secret_data = module.ssh_key.tls_private_key.private_key_openssh // This is the value of the secret
  depends_on  = [google_secret_manager_secret.ssh_key_vm_skk_debian]
}

resource "github_actions_secret" "ssh_key" {
  repository      = "${var.org}-${var.app}-wui"
  secret_name     = "SSH_KEY_${upper(var.org)}_${upper(var.app)}_${upper(var.env)}"
  plaintext_value = module.ssh_key.tls_private_key.private_key_openssh
}
