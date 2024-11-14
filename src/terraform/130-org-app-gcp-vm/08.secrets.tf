# MUST give the gcp some time to spawn the instance !!!
resource "time_sleep" "wait_50_seconds" {
  depends_on = [module.gcp_compute_instance.instance]

  create_duration = "50s"

}

resource "random_password" "db_password_root" {
  length = 10
  special = false
}

resource "google_secret_manager_secret" "db_password_root" {
  secret_id = "db-password-${var.org}-${var.app}-${var.env}-${var.app}-root"

  replication {
    automatic = true // this is not an error dont change it
  }
}

resource "google_secret_manager_secret_version" "db_password_secret_version_root" {
  secret      = google_secret_manager_secret.db_password_root.id
  secret_data = random_password.db_password_root.result // This is the value of the secret
  depends_on  = [google_secret_manager_secret.db_password_root]
}


resource "random_password" "db_password" {
  length = 10
  special = false
}

resource "google_secret_manager_secret" "db_password" {
  secret_id = "db-password-${var.org}-${var.app}-${var.env}-${var.app}"

  replication {
    automatic = true // this is not an error, do NOT change it !!!
  }
}

resource "google_secret_manager_secret_version" "db_password_secret_version" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = random_password.db_password.result // This is the value of the secret
  depends_on  = [google_secret_manager_secret.db_password]
}

resource "random_password" "wp_admin_password" {
  length = 15
  special = false
}

resource "google_secret_manager_secret" "wp_admin_password" {
  secret_id = "wp-admin-${var.org}-${var.app}-${var.env}-${var.app}"

  replication {
    automatic = true // this is not an error, do NOT change it !!!
  }
}

resource "google_secret_manager_secret_version" "wp_admin_password_secret_version" {
  secret      = google_secret_manager_secret.wp_admin_password.id
  secret_data = random_password.wp_admin_password.result // This is the value of the secret
  depends_on  = [google_secret_manager_secret.wp_admin_password]
}


