terraform {
  required_version = "1.2.2"

  required_providers {
    aws = {
      version = ">= 4.13.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "google" {
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
  credentials = file(pathexpand("~/.gcp/.${var.org}/key-${var.org}-${var.app}-${var.env}.json"))
}
