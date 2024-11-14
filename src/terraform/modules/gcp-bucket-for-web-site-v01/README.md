# GCP Bucket for Website Module - v01

## Description
This module sets up a Google Cloud Storage bucket for hosting a website. It includes configurations for CORS, versioning, and public read access.


## Usage

```hcl
module "gcp_bucket_for_website" {
  source  = "../modules/gcp-bucket-for-web-site-v01"

  org                      = var.org
  app                      = var.app
  env                      = var.env
  gcp_project              = var.gcp_project
  bucket_name              = var.bucket_name
  bucket_region            = var.bucket_region
  bucket_enable_versioning = var.bucket_enable_versioning
  bucket_force_destroy     = var.bucket_force_destroy
  bucket_storage_class     = var.bucket_storage_class
  wpb_fqdn                 = var.wpb_fqdn
}

## TODO

Add Editor and Owner role based iam access to gcp
