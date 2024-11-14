terraform {
  required_version = "1.2.2"

  required_providers {
    aws = {
      version = ">= 4.13.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
  shared_config_files = [pathexpand(var.shared_config_files)]
  shared_credentials_files = [pathexpand(var.shared_credentials_files)]

  default_tags {
    tags = {
      ORG         = var.org
      APP         = var.app
      ENV         = var.env
      CNF_VER     = var.CNF_VER
      INFRA_VERSION = var.INFRA_VERSION
      TERRAFORM_VERSION = var.TERRAFORM_VERSION
    }
  }
}