terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.81.0"
    }
  }
  backend "gcs" {}
}


provider "google" {
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
  #                          /home/ysg/.gcp/.ilm/key-str-sol-dev.json
  credentials = file(pathexpand("~/.gcp/.${var.org}/key-${var.org}-${var.app}-${var.env}.json"))
}


provider "google" {
  alias       = "prd"
  project     = "${var.org}-${var.app}-prd"
  region      = var.gcp_region
  zone        = var.gcp_zone
  #                          /home/ysg/.gcp/.ilm/key-str-sol-prd.json
  credentials = file(pathexpand("~/.gcp/.${var.org}/key-${var.org}-${var.app}-prd.json"))
}

# OBS all-all and NOT sol-all, because the ilmatarbrain.com is in all-all
# as thee MIGHT be other applications in the future not only solutinos
# and yes this might be a troublesome naming convention one day

# Provider for the all_org (managing DNS at the top level, e.g., flk-all-all)
provider "google" {
  alias       = "all"
  project     = "${var.all_org}-all-all"
  region      = var.gcp_region
  zone        = var.gcp_zone
  credentials = file(pathexpand("~/.gcp/.${var.all_org}/key-${var.all_org}-all-all.json"))
}
