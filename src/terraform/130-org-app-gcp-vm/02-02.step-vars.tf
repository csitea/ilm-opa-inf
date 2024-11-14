variable "google_compute_disk_type" {
  type        = string
  description = "The disk type of the compute engine virtual machine"
  default = "pd-ssd"
}

variable "google_compute_disk_size" {
  type        = string
  description = "The disk size of the compute engine virtual machine in GB"
  default = "20"
}

variable "google_compute_instance_machine_type" {
  type        = string
  description = "The type size of the compute engine virtual machine from the gcp"
  default = "e2-micro"
}

variable google_compute_instance_machine_image {
  type        = string
  description = "The name of the image  of the compute engine virtual machine as defined in the gcp"
  default = "debian-cloud/debian-10"

}

variable "box_domain_email" {
  type        = string
  description = "The email to use for the SSL requests with certbot"
  default = "sys@flok.fi"
}

variable "google_compute_boot_disk_size" {
  type        = number
  description = "The amount of gigabytes in the boot disk"
  default = 30
}

variable "host_name" {
  type = string
  description = "the bare HOST_NAME"
}

variable "fqn_host_name" {
  type = string
  description = "the fully qualified HOST_NAME to provision"
}

variable "use_staging_ssl" {
  type = string
  description = "If the certbot is going to use the staging environment"
  default = "true"
}

variable "gcp_vm_name" {
  type = string
  description = "The name of the compute engine virtual machine"
}
