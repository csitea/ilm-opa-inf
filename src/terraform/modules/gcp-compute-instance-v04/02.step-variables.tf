
variable "host_name" {
  type = string
  description = "Unique name for the resource, will be concatinated with org app env"
}

variable "network" {
  type = string
  default = "default"
}

variable "tls_private_key" {
  type = object({
    id = string
    public_key_openssh = string
  })
  sensitive = true
}

variable "machine_image" {
  type = string
  default = "debian-cloud/debian-11"
}

variable "machine_type" {
  type = string
}

variable "disk_size" {
  type = string
}

variable "disk_type" {
  type = string
}

variable "instance_tags" {
  type = list(string)
  default = []
}

variable "user" {
  description = "The user used for ssh connections"
}

variable "google_compute_boot_disk_size" {
  type        = number
  description = "The amount of gigabytes in the boot disk"
  default = 30
}
