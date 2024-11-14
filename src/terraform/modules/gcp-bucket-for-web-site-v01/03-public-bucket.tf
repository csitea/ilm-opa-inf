resource "google_storage_bucket" "default" {
  # googleapi: Error 400: The specified bucket contains a '.'
  # but is not under a currently recognized top-level domain., invalid
  name          = replace(var.bucket_name, ".", "-")
  force_destroy = var.bucket_force_destroy
  location      = var.bucket_region
  storage_class = var.bucket_storage_class

  versioning {
    enabled = var.bucket_enable_versioning
  }

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

  cors {
    origin          = ["http://${var.wpb_fqdn}", "https://${var.wpb_fqdn}"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }


  # Enable Uniform bucket-level access to simplify ACL management
  uniform_bucket_level_access = true

    labels = {
    org = var.org
    app = var.app
    env = var.env
    gcp_project = var.gcp_project
  }
}

# Set the bucket to be publicly readable using IAM
resource "google_storage_bucket_iam_member" "public_read" {
  bucket = google_storage_bucket.default.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

