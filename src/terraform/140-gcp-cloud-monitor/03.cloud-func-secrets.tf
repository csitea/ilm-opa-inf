data "external" "fetch_smtp_password" {
  program = ["bash", "${var.proj_path}/src/terraform/140-gcp-cloud-monitor/fetch-pw.sh" , "${var.org}", "${var.app}", "${var.env}", "${var.base_path}" , "${var.kbdx_db_key_file_name}"]
}

resource "google_secret_manager_secret" "password_smtp_sys" {
  secret_id = "smtp-password-${var.org}-${var.app}-${var.env}"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "smtp_password_secret_version" {
  secret      = google_secret_manager_secret.password_smtp_sys.id
  secret_data = data.external.fetch_smtp_password.result["password"]
}


# debug

output "debug_org" {
  value       = var.org
  description = "Debug output for the org variable"
}

output "debug_app" {
  value       = var.app
  description = "Debug output for the app variable"
}

output "debug_env" {
  value       = var.env
  description = "Debug output for the env variable"
}

output "debug_base_path" {
  value       = var.base_path
  description = "Debug output for the base_path variable"
}

output "debug_kbdx_db_key_file_name" {
  value       = var.kbdx_db_key_file_name
  description = "Debug output for the kbdx_db_key_file_name variable"
}
