output "tls_private_key" {
  value = tls_private_key.ssh_key_vm
}

output "private_key_file" {
  value = local_sensitive_file.private_key
}

output "public_key_file" {
  value = local_file.public_key
}

output "private_key_path" {
  value = local.private_key_path
}

output "tilded_private_key_path" {
  value = "~/.ssh/.${var.org}/${local.ssh_key_name}.pk"
}
