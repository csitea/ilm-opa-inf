variable "gcp_services" {
  description = "List of Google Cloud services to enable."
  type        = list(string)
  default     = [
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "storage.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com",
    "bigquery.googleapis.com",
    "cloudscheduler.googleapis.com",
    "sqladmin.googleapis.com",
    "iam.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com",
  ]
}

resource "google_project_service" "project_service" {
  for_each = toset(var.gcp_services)

  service            = each.key
  disable_dependent_services = true
}
