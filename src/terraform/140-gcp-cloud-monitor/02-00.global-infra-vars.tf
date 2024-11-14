# START ::: INFRA VARS
variable "org" {
  type        = string
  description = "the 3-letter code of the organisation used in the account name"
}

variable "app" {
  type        = string
  description = "The current application name."
}

variable "env" {
  type        = string
  description = "The current environment."
}

variable "proj_path" {
  type        = string
  description = "The root dir of the sfw project"
}

variable "base_path" {
  type        = string
  description = "The base directory such as /opt or /var or /home/osusr/opt"
}

variable "org_path" {
  type        = string
  description = "The parent of the product dir"
}

variable "TERRAFORM_VERSION" {
  type        = string
  description = "Version of terraform runtime used to provision this resource"
}

variable "INFRA_VERSION" {
  type        = string
  description = "Version of infra code"
}

variable "CNF_VER" {
  type        = string
  description = "Version of configuration"
}

variable "STEP" {
  type        = string
  description = "the current step"
}

variable "bucket_name" {
  description = "Name of the bucket for Cloud Function source code"
  type        = string
}


# STOP  ::: INFRA VARS
