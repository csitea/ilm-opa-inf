output "instance" {
  value = google_compute_instance.virtual_machine
}

output "disk" {
  value = google_compute_disk.disk
}

output "instance_public_ip" {
  value = google_compute_instance.virtual_machine.network_interface.0.access_config.0.nat_ip
}

# Output the service account email
output "wordpress_service_account_email" {
  value = google_service_account.sa_compute_instance.email
}
