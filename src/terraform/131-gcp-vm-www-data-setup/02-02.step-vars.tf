variable "host_name" {
  type = string
  description = "the bare host_name"
}

variable "fqn_host_name" {
  type = string
  description = "the fully qualified HOST_NAME to provision"
  default = ""
}

variable "gcp_vm_name" {
  type = string
  description = "the gcp vm name as seen in the gcp admin console"
  default = "<<app>>-<<env>>-<<box-name>>-vm"
 }
