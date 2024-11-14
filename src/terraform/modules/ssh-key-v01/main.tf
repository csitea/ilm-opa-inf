resource "tls_private_key" "ssh_key_vm" {
  algorithm = var.algorithm
}

resource "local_sensitive_file" "private_key" {
  content = tls_private_key.ssh_key_vm.private_key_openssh
  filename = local.private_key_path
  file_permission = "0600"
}

resource "local_file" "public_key" {
  content = tls_private_key.ssh_key_vm.public_key_openssh
  filename = local.public_key_path
  file_permission = "0644"
}

# to use them else where :
# pathexpand("~/.ssh/.${var.org}/${var.org}-${var.app}-${var.env}-${var.name}.pk")
locals {
  ssh_key_name = "${var.org}-${var.app}-${var.env}-${var.key_name}"
  private_key_path = pathexpand("~/.ssh/.${var.org}/${local.ssh_key_name}.pk")
  public_key_path  = pathexpand("~/.ssh/.${var.org}/${local.ssh_key_name}.pk.pub")
}
