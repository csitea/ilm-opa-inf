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
  default     = "europe-north1-b"

}

variable "gcp_subzone_domain" {
  type        = string
  description = "The GCP subzone."
}

variable "gcp_subzone_name" {
  type        = string
  description = "The GCP subzone name."
}

variable "fqn_web_app_subdomain" {
  type        = string
  description = "The fully qualified web app subdomain."
}

variable "fqn_env_subdomain" {
  type = string
  description = "value of the fully qualified environment subdomain"
}

variable "tld_zone_name" {
  type        = string
  description = "The top level domain zone name."
}



variable "prd_zone_name" {
  type        = string
  description = "The name of the production subzone."
}

variable "gcp_sa_email" {
  type        = string
  description = "The GCP service account email."
}
