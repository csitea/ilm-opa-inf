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
  credentials = file(pathexpand("~/.gcp/.${var.org}/key-${var.org}-${var.app}-${var.env}.json"))
}