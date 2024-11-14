# DO NOT UNCOMMENT THOSE RESOURCES!!!
# THIS IS JSUT TO REMÍND THAT ALL OF THOSE MUST BE ENABLED BEFOREHAND
# DURING THE GCP PROJECT CREATION

# resource "google_project_service" "cloud_functions_api" {
#   service  = "cloudfunctions.googleapis.com"
#   project  = var.gcp_project
# }

# resource "google_project_service" "iam_api" {
#   service  = "iam.googleapis.com"
#   project  = var.gcp_project
# }

# resource "google_project_service" "cloud_scheduler_api" {
#   service  = "cloudscheduler.googleapis.com"
#   project  = var.gcp_project
# }

# resource "google_project_service" "cloud_storage_api" {
#   service  = "storage.googleapis.com"
#   project  = var.gcp_project
#   disable_dependent_services = true
#   depends_on = [ google_project_service.cloudapis_api ]
# }

# resource "google_project_service" "compute_engine_api" {
#   service  = "compute.googleapis.com"
#   project  = var.gcp_project
# }

# resource "google_project_service" "cloudapis_api" {
#   service  = "cloudapis.googleapis.com"
#   project  = var.gcp_project
# }
