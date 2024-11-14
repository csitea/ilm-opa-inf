variable "org" {
  type        = string
  description = "The 3 letters code of the organization used in the account name."
}

variable "app" {
  type        = string
  description = "The current application name."
}

variable "env" {
  type        = string
  description = "The current environment."
}

variable "gcp_region" {
  type        = string
  description = "The GCP region."
  default     = "europe-north1"
}

variable "gcp_project" {
  type        = string
  description = "The GCP project."
}

variable "gcp_zone" {
  type        = string
  description = "The GCP zone."
  default     = "europe-north1-a"

}

variable "bucket_name" {
  type = string
  description = "the name of the state bucket"
  default = ""
}


variable "org" {
  type = string
  description = "GCP Project ORG"
}

variable "app" {
  type = string
  description = "GCP Project APP"
}
