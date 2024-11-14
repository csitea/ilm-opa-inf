# # Create a service account for the compute instance
# resource "google_service_account" "sa_compute_instance" {
#   account_id   = "sa-compute-instance"
#   display_name = "WordPress Compute Instance Service Account"
# }

# # Assign roles to the service account
# resource "google_project_iam_member" "sa_compute_instance_storage_viewer" {
#   project = var.gcp_project
#   role    = "roles/storage.objectViewer"
#   member  = "serviceAccount:${google_service_account.sa_compute_instance.email}"
# }

# resource "google_project_iam_member" "sa_compute_instance_storage_admin" {
#   project = var.gcp_project
#   role    = "roles/storage.admin"
#   member  = "serviceAccount:${google_service_account.sa_compute_instance.email}"
# }


resource "google_service_account" "sa_compute_instance" {
  account_id   = "sa-compute-instance"
  display_name = "WordPress Compute Instance Service Account"
}

# Assign roles to the service account
resource "google_project_iam_member" "sa_compute_instance_storage_viewer" {
  project = var.gcp_project
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.sa_compute_instance.email}"

  # Ensure this IAM binding is destroyed before the service account
  depends_on = [google_service_account.sa_compute_instance]
}

resource "google_project_iam_member" "sa_compute_instance_storage_admin" {
  project = var.gcp_project
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.sa_compute_instance.email}"

  # Ensure this IAM binding is destroyed before the service account
  depends_on = [google_service_account.sa_compute_instance]
}
