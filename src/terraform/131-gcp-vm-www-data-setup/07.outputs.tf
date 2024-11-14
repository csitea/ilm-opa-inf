output "gcp_vm_name" {
  description = "value = data.google_compute_instance.gcp_vm.name"
  value = data.google_compute_instance.gcp_vm.name
}


# output "gcp_vm_ip" {
#    value = data.google_compute_instance.gcp_vm.network_interface.0.access_config.0.nat_ip
# }

output "DNS_entry" {
  value = "${var.fqn_host_name}"
  description = "The dns entry on which the site is registered"
}

output "SITE_URL" {
  value = "https://${var.fqn_host_name}"
  description = "Point your browser at this url to start installing WP ... "
}


output "ssh_config_instructions" {
  value = <<-EOT
To connect to the provisioned resources, use the following SSH configuration:

Host ${var.fqn_host_name}
    User www-data
    HostName ${var.fqn_host_name}
    IdentityFile "~/.ssh/.${var.org}/${var.org}-${var.app}-${var.env}-${var.host_name}-www-data.pk"
    IdentitiesOnly yes

This configuration has been appended to your local ~/.ssh/config file. Share these details responsibly with others who need access. Ensure the IdentityFile path is correct and the private key is securely managed.

Add also this value to the according project credentials files !!!

/opt/${var.org}/${var.org}-${var.app}/${var.org}-creds/${var.org}-creds.kdbx
and push to
https://github.com/csitea/${var.org}-${var.app}-crs


EOT

  description = "Instructions for using the generated SSH configuration."
}
