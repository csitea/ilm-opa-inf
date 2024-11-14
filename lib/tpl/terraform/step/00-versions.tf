terraform {
  required_version = "1.2.2"

  required_providers {
    aws = {
      version = ">= 4.13.0"
      source  = "hashicorp/aws"
    }
  }

  backend "s3" {} # will be filled by backend-config file
}
