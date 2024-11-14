output "instance_ssh_cmd_by_ip" {
  value = "ssh -o IdentitiesOnly=yes -i ${module.ssh_key.tilded_private_key_path} debian@${module.gcp_compute_instance.instance_public_ip}"
  description = "The command to use if you want to ssh to the gitlab VM"
}

output "instance_ssh_cmd_by_dns" {
  value = "ssh -o IdentitiesOnly=yes -i ${module.ssh_key.tilded_private_key_path} debian@${var.fqn_host_name}"
  description = "The command to use if you want to ssh to the gitlab VM"
}

output "DNS_entry" {
  value = "${var.fqn_host_name}"
  description = "The dns entry on which the site is registered"
}

output "SITE_URL" {
  value = "https://${var.fqn_host_name}"
  description = "Point your browser at this url to start installing WP ... "
}

output "db_password" {
  value = nonsensitive(random_password.db_password.result)
  description = "Add the wordpress db passwords to the project's creds !!!"
}

output "db_password_root" {
  value = nonsensitive(random_password.db_password_root.result)
  description = "Add the root db passwords to the project's creds !!!"
}

output "wp_admin_username" {
  value = "wp_admin"
  description = "Add the wp_admin usename to the project's creds !!!"
}

output "wp_admin_password" {
  value = nonsensitive(random_password.wp_admin_password.result)
  description = "Add the wp_admin passwords to the project's creds !!!"
}

output "tilded_private_key_to_add_to_creds" {
  value = "${module.ssh_key.tilded_private_key_path}"
  description = "Add this private key file to the project's creds !!!"
}

output "tilded_public_key_to_add_to_creds" {
  value = "${module.ssh_key.tilded_private_key_path}.pub"
  description = "Add this public key file to the project's creds !!!"
}
