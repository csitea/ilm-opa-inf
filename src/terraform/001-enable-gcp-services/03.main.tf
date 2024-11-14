module "enable_gcp_services" {
  source = "../modules/gcp-services"

  gcp_project_id = var.gcp_project

    providers = {
      google = google
    }
}
