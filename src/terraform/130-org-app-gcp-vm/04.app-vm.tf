module "gcp_compute_instance" {
  source  = "../modules/gcp-compute-instance-v04"
  app     = var.app
  env     = var.env
  org    = var.org
  gcp_project = var.gcp_project

  disk_size = var.google_compute_disk_size
  disk_type = var.google_compute_disk_type
  google_compute_boot_disk_size = var.google_compute_boot_disk_size
  instance_tags = ["allow-https-${var.org}-${var.app}-${var.env}", "allow-https"]
  machine_image = var.google_compute_instance_machine_image
  machine_type  = var.google_compute_instance_machine_type
  host_name = var.host_name
  tls_private_key = module.ssh_key.tls_private_key
  user = "debian"

}


resource "null_resource" "update_known_hosts" {
  triggers = {
    instance_ip = module.gcp_compute_instance.instance_public_ip
    fqn_host_name = var.fqn_host_name
  }

  provisioner "local-exec" {
    command = <<-EOT
      ssh-keygen -f "/home/appusr/.ssh/known_hosts" -R ${module.gcp_compute_instance.instance_public_ip} || true
      ssh-keygen -f "/home/appusr/.ssh/known_hosts" -R "${var.fqn_host_name}" || true

      ssh-keyscan -H ${module.gcp_compute_instance.instance_public_ip} >> /home/appusr/.ssh/known_hosts || true
      ssh-keyscan -H "${var.fqn_host_name}" >> /home/appusr/.ssh/known_hosts || true
    EOT
  }

  # to uncomment if non-manual DNS is used
  # depends_on = [ google_dns_record_set.wpb_vm_record ]
}
