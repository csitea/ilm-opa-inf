variable "gcp_region" {
  type        = string
  description = "The GCP region, where resources will be created"
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
