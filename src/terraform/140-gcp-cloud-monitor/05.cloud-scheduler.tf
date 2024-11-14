# Cloud Scheduler job to trigger the Cloud Function every hour
resource "google_cloud_scheduler_job" "monitor_urls_job" {
  name             = "cloud-monitor-scheduler-job"
  description      = "Job to trigger the cloud monitor function."
  #  schedule      = "0 * * * *"  # Every hour
  # schedule       = "*/3 * * * *"  # Every 5 minutes
  schedule         =  var.cron_schedule
  time_zone        = "UTC"
  region           = var.gcp_region

  http_target {
    http_method = "POST"
    uri         = google_cloudfunctions_function.cloud_monitor_function.https_trigger_url
    oidc_token {
      service_account_email = google_service_account.scheduler_sa.email
    }
  }
}

# Create Service Account for Cloud Scheduler
resource "google_service_account" "scheduler_sa" {
  account_id   = "cloud-scheduler-sa"
  display_name = "Cloud Scheduler Service Account"
}

# Assign IAM roles to allow the scheduler to invoke Cloud Functions
resource "google_project_iam_member" "scheduler_invoker" {
  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:${google_service_account.scheduler_sa.email}"
  project = var.gcp_project
}

# Assign IAM roles to the Cloud Function for Cloud Logging
resource "google_project_iam_member" "function_logger" {
  role   = "roles/logging.logWriter"
  member = "serviceAccount:${google_cloudfunctions_function.cloud_monitor_function.service_account_email}"
  project = var.gcp_project
}

# Outputs
output "cloud_function_url" {
  description = "The URL to trigger the Cloud Function"
  value       = google_cloudfunctions_function.cloud_monitor_function.https_trigger_url
}

resource "google_project_iam_member" "cloud_scheduler_service_account_invoker" {
  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:${google_service_account.scheduler_sa.email}"
  project = var.gcp_project
}

resource "google_project_iam_member" "cloud_scheduler_service_account_user" {
  role   = "roles/iam.serviceAccountUser"
  member = "serviceAccount:${google_service_account.scheduler_sa.email}"
  project = var.gcp_project
}

resource "google_project_iam_member" "cloud_function_service_account_logger" {
  role   = "roles/logging.logWriter"
  member = "serviceAccount:${google_cloudfunctions_function.cloud_monitor_function.service_account_email}"
  project = var.gcp_project
}


# Allow only the service account to invoke the function in production
resource "google_cloudfunctions_function_iam_member" "invoker_permission" {
  count          = var.env == "prd" ? 1 : 0
  project        = var.gcp_project
  region         = var.gcp_region
  cloud_function = google_cloudfunctions_function.cloud_monitor_function.name

  role   = "roles/cloudfunctions.invoker"
  member = "serviceAccount:${google_service_account.scheduler_sa.email}"  # Restrict to scheduler service account
}
