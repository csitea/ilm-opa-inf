resource "google_storage_bucket" "default" {
  # googleapi: Error 400: The specified bucket contains a '.' but is not under a currently recognized top-level domain., invalid
  name          = replace(var.bucket_name, ".", "-")
  force_destroy = var.bucket_force_destroy
  location      = var.bucket_region
  storage_class = var.bucket_storage_class

  versioning {
    enabled = var.bucket_enable_versioning
  }

}
