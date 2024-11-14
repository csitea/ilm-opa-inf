variable "bucket_name" {
    type = string
    description = "name of state bucket"
}

variable "bucket_region" {
    type = string
    description = "region of state bucket"
    default = "europe-north1"
}

variable "bucket_enable_versioning" {
    type = bool
    description = "enable versioning of state bucket"
    default = true
}

variable "bucket_force_destroy" {
    type = bool
    description = "force destroy of state bucket"
    default = true
}

variable "bucket_storage_class" {
    type = string
    description = "storage class of state bucket"
    default = "STANDARD"
}

variable "keyring_name" {
    type = string
    description = "name of keyring"
    default = ""
}

variable "keyring_rotation" {
    type = string
    description = "rotation period of keyring"
    default = "100000s"
}

