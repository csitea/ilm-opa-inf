module "state_bucket" {
  source  = "../modules/state-bucket-gcp"
  bucket_name = try(var.bucket_name, "${var.org}-${var.app}-${var.env}-gcp-remote-bucket-tfstate")
  #keyring_name = "${var.org}-${var.app}-${var.env}.120-vse-gcp-${var.app}-vm-remote-bucket.terraform-state"
}
