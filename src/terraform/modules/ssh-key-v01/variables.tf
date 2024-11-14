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

variable "key_name" {
  type = string
  description = "Unique name for the resource, will be concatinated with org app env and key"
}

variable "algorithm" {
  default = "ED25519"
  description = "The algorithm to be used for key generation"
}
