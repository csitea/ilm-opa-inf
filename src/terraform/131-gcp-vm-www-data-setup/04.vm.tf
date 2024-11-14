data "google_compute_instance" "gcp_vm" {
  name    = var.gcp_vm_name
  project = var.gcp_project
  zone    = var.gcp_zone
}
