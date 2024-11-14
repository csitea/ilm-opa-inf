# The following resource should be deleted manually
# https://console.cloud.google.com/storage/browser?project=ilm-opa-dev&prefix=&forceOnBucketsSortingFiltering=true&pageState=(%22StorageBucketsTable%22:(%22f%22:%22%255B%255D%22,%22s%22:%5B(%22i%22:%22name%22,%22s%22:%220%22)%5D,%22r%22:30))

module "bucket" {

  source = "../modules/gcp-bucket-for-web-site-v01"
  for_each = { for b in var.buckets : b.name => b }

  org = var.org
  app = var.app
  env = var.env
  gcp_project = var.gcp_project

  bucket_name = each.value.name
  bucket_region = each.value.location
  bucket_enable_versioning = each.value.enable_versioning
  bucket_force_destroy = each.value.force_destroy
  bucket_storage_class = each.value.storage_class
  wpb_fqdn = var.wpb_fqdn
}
