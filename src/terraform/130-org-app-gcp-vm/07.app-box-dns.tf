# Fetching the managed DNS zone information
data "google_dns_managed_zone" "subzone_gcp" {
  name = "${var.org}-${var.app}-${var.env}-subzone"
}

# A record for the VM
resource "google_dns_record_set" "wpb_vm_record" {
  name         = "${var.fqn_host_name}."
  type         = "A"
  ttl          = 300
  managed_zone = data.google_dns_managed_zone.subzone_gcp.name
  rrdatas      = [module.gcp_compute_instance.instance_public_ip]
}

# CNAME record for the www subdomain
resource "google_dns_record_set" "wpb_vm_record_cname" {
  name         = "www.${var.fqn_host_name}."
  type         = "CNAME"
  ttl          = 300
  managed_zone = data.google_dns_managed_zone.subzone_gcp.name
  rrdatas      = ["${var.fqn_host_name}."]
}

# CAA record to explicitly allow Let's Encrypt to issue certificates
resource "google_dns_record_set" "wpb_vm_record_caa" {
  name         = "${var.fqn_host_name}."
  type         = "CAA"
  ttl          = 300
  managed_zone = data.google_dns_managed_zone.subzone_gcp.name
  rrdatas      = ["0 issue \"letsencrypt.org\""]
}
