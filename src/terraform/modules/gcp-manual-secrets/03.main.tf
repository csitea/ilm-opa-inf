# Secret values are inserted manually in cloud console after creation

# API key value is copied from ilmatar-price-forecast project
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.81.0"
    }
  }
}

resource "google_secret_manager_secret" "proj_sa_acc_key" {


  secret_id = "${var.proj_sa_acc_key_secret_id}"

  replication {
    automatic = true
  }


}
