terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.81.0"
    }
  }
  backend "gcs" {}
}

provider "github" {
  owner = "csitea"
}