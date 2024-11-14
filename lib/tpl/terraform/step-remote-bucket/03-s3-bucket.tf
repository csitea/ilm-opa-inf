module "state_bucket" {
  source  = "../modules/state-bucket"
  bucket_name = "${var.org}-${var.app}-${var.env}.step-name-remote-bucket.terraform-state"
  dynamo_name = "terraform-lock-${var.org}-${var.app}-${var.env}-step-name-remote-bucket"
}
