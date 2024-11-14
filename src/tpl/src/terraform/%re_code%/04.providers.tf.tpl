provider "aws" {
  region  = var.region
  profile = var.profile
  shared_config_files      = [pathexpand(var.shared_config_files)]
  shared_credentials_files = [pathexpand(var.shared_credentials_files)]

  default_tags {
    tags = {
      ORG         = var.org
      APP         = var.app
      ENV         = var.env
      CNF_VER     = var.CNF_VER
      STEP   = var.STEP
      INFRA_VERSION = var.INFRA_VERSION
      TERRAFORM_VERSION = var.TERRAFORM_VERSION
    }
  }
}


provider "aws" {
  alias                    = "virginia"
  region                   = "us-east-1"
  profile                  = var.profile
  shared_config_files      = [pathexpand(var.shared_config_files)]
  shared_credentials_files = [pathexpand(var.shared_credentials_files)]

  default_tags {
    tags = {
      ORG = var.org
      APP = var.app
      ENV = var.env
      STEP   = var.STEP
    }
  }
}

