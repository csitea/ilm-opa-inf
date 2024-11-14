variable "buckets" {
  type = list(object({
    enable_versioning: bool
    force_destroy: bool
    location: string
    name: string
    storage_class: string
  }))
  description = "The list of buckets to create"
}


variable "wpb_fqdn" {
  type = string
  description = "The FQDN of the web site"

}
