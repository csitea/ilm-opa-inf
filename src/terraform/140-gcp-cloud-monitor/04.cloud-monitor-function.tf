# Create Google Cloud Storage bucket to upload the Cloud Function source code
resource "google_storage_bucket" "function_code_bucket" {
  name     = "${var.gcp_project}-function-code-bucket"
  location = var.gcp_region
  force_destroy = true
}


resource "null_resource" "zip_and_upload_cloud_function" {
  provisioner "local-exec" {
    command = <<EOL
    set -x
    export GOOGLE_APPLICATION_CREDENTIALS="/home/appusr/.gcp/.${var.org}/key-${var.org}-${var.app}-${var.env}.json" && \
    cd ${var.proj_path}/src/python/cloud-monitor && \
    rm -f function-source.zip || true && \
    zip -r function-source.zip main.py requirements.txt && \
    gsutil rm gs://${google_storage_bucket.function_code_bucket.name}/cloud-monitor/function-source.zip || true && \
    gsutil cp function-source.zip gs://${google_storage_bucket.function_code_bucket.name}/cloud-monitor/
    EOL
  }

  triggers = {
    always_run = "${timestamp()}"  # Forces the resource to re-run every apply
  }

  depends_on = [google_storage_bucket.function_code_bucket]
}

resource "google_storage_bucket_iam_member" "cloud_function_storage_access1" {
  bucket = google_storage_bucket.function_code_bucket.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_cloudfunctions_function.cloud_monitor_function.service_account_email}"
}


# You can retrieve the project number from your environment:
data "google_project" "project" {}

# Assign project_number from the data source
output "project_number" {
  value = data.google_project.project.number
}

resource "google_storage_bucket_iam_member" "cloud_function_storage_access2" {
  bucket = google_storage_bucket.function_code_bucket.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:service-${data.google_project.project.number}@gcf-admin-robot.iam.gserviceaccount.com"
}

resource "google_storage_bucket_iam_member" "cloud_function_storage_writer" {
  bucket = google_storage_bucket.function_code_bucket.name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:service-${data.google_project.project.number}@gcf-admin-robot.iam.gserviceaccount.com"
}


# Upload Python code for Cloud Function
resource "google_storage_bucket_object" "cloud_monitor_code" {
  name   = "cloud-monitor/main.py"
  bucket = google_storage_bucket.function_code_bucket.name
  source = "${var.proj_path}/src/python/cloud-monitor/main.py"
}


# Define Cloud Function
resource "google_cloudfunctions_function" "cloud_monitor_function" {
  name        = "cloud-monitor-function"
  runtime     = "python39"
  entry_point = "check_urls_and_send_email"
  region      = var.gcp_region

  source_archive_bucket = google_storage_bucket.function_code_bucket.name
  source_archive_object = "cloud-monitor/function-source.zip"

  trigger_http = true
  timeout      = 300  # Adjust as needed

  environment_variables = {
    SENDER_EMAIL    = var.sender_email
    RECIPIENT_EMAIL = var.recipient_email
    SMTP_SERVER     = var.smtp_server
    SMTP_PORT       = var.smtp_port
    SMTP_USERNAME   = var.smtp_username
    GCP_PROJECT     = var.gcp_project
    # Do not set SMTP_PASSWORD here; instead, map the secret
  }

  https_trigger_security_level = "SECURE_ALWAYS"
  depends_on = [null_resource.zip_and_upload_cloud_function]
}

resource "google_project_iam_member" "function_secret_access" {
  project = var.gcp_project
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_cloudfunctions_function.cloud_monitor_function.service_account_email}"
}
