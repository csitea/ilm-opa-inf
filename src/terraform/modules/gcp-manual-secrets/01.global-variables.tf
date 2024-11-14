variable "org" {
  type        = string
  description = "The current organization name."
}
variable "app" {
  type        = string
  description = "The current application name."
}

variable "env" {
  type        = string
  description = "The current environment."
}

variable "gcp_project" {
  type = string
  description = "the gcp project "
}
