resource "google_storage_bucket" "default" {
  name          = replace(var.bucket_name, ".", "-")
  force_destroy = var.bucket_force_destroy
  location      = var.bucket_region
  storage_class = var.bucket_storage_class

  versioning {
    enabled = var.bucket_enable_versioning
  }

  # Enable uniform bucket-level access as an attribute
  uniform_bucket_level_access = true
}
