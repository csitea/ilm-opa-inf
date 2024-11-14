# The following resource should be deleted manually
module "bucket" {
  source  = "../modules/gcp-bucket"
  for_each = { for b in var.buckets : b.name => b }

  bucket_name = each.value.name
  bucket_region = each.value.location
  bucket_enable_versioning = each.value.enable_versioning
  bucket_force_destroy = each.value.force_destroy
  bucket_storage_class = each.value.storage_class
}
