resource "null_resource" "remove_old_host_keys" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<-EOT
      # Remove the old host keys for the IP and hostname
      ssh-keygen -f "/home/appusr/.ssh/known_hosts" -R ${data.google_compute_instance.gcp_vm.network_interface[0].access_config[0].nat_ip} || true
      ssh-keygen -f "/home/appusr/.ssh/known_hosts" -R "${var.fqn_host_name}" || true
    EOT
  }
  depends_on = [ null_resource.generate_inventory_ini, module.ssh_key, null_resource.remove_old_host_keys ]
}

module "ssh_key" {
  source        = "../modules/ssh-key-v01"

  org           = var.org
  app           = var.app
  env           = var.env
  key_name      = "${var.host_name}-www-data"
}

resource "google_secret_manager_secret" "ssh_key_vm_www_data" {
  secret_id = "ssh-key-${var.org}-${var.app}-${var.env}-${var.host_name}-www-data-vm"

  replication {
    automatic = true // this is not an error dont change it
  }
depends_on = [ null_resource.remove_old_host_keys ]
}


resource "null_resource" "generate_inventory_ini" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {

command = <<-EOT
  echo '[hosts]' > ${var.proj_path}/src/terraform/${var.STEP}/inventory.${var.env}.ini
  echo '${data.google_compute_instance.gcp_vm.network_interface[0].access_config[0].nat_ip} ansible_user=debian ansible_ssh_private_key_file=/home/appusr/.ssh/.${var.org}/${var.org}-${var.app}-${var.env}-${var.host_name}.pk' >> ${var.proj_path}/src/terraform/${var.STEP}/inventory.${var.env}.ini
EOT

  }
}

output "debug_host_name" {
  value = var.host_name
}




resource "google_secret_manager_secret_version" "ssh_key_vm_www_data_secret_version" {
  secret      = google_secret_manager_secret.ssh_key_vm_www_data.id
  secret_data = module.ssh_key.tls_private_key.private_key_openssh // This is the value of the secret
  depends_on  = [google_secret_manager_secret.ssh_key_vm_www_data]
}


resource "null_resource" "ansible-playbook" {
  triggers = {
    always_run = "${timestamp()}"
  }
  # /home/ysg/.ssh/.str/ilm-opa-dev-doc-www-data.pk
  provisioner "local-exec" {
    command = <<-EOF
      ssh-keyscan -H ${data.google_compute_instance.gcp_vm.network_interface[0].access_config[0].nat_ip} >> ~/.ssh/known_hosts &&
      ansible-playbook ${var.proj_path}/src/terraform/${var.STEP}/wordpress-playbook.yaml \
      -i ${var.proj_path}/src/terraform/${var.STEP}/inventory.${var.env}.ini \
      --user debian \
      -b \
      -e ansible_python_interpreter=/usr/bin/python3 \
      -e org='${var.org}' \
      -e app='${var.app}' \
      -e env='${var.env}' \
      -e fqn_host_name='${var.fqn_host_name}' \
      -e host_name='${var.host_name}' \
      -e www_data_private_key_path="/home/appusr/.ssh/.${var.org}/${var.org}-${var.app}-${var.env}-${var.host_name}-www-data.pk" \
      -e www_data_public_key_path="/home/appusr/.ssh/.${var.org}/${var.org}-${var.app}-${var.env}-${var.host_name}-www-data.pk.pub"
    EOF
  }
  depends_on = [ null_resource.generate_inventory_ini, module.ssh_key]
}


# /home/ysg/.ssh/.esg/esg-whd-dev-etl.pk
resource "ansible_host" "whd_vm_wordpress" {
  name = "${var.gcp_vm_name}"
  groups = ["wordpress"]
  variables = {
    ansible_user                  = "debian",
    ansible_ssh_private_key_file  = pathexpand("~/.ssh/.${var.org}/${var.org}-${var.app}-${var.env}-${var.host_name}.pk"),
    ansible_python_interpreter    = "/usr/bin/python3",
    server_ipv4                   = data.google_compute_instance.gcp_vm.network_interface[0].access_config[0].nat_ip,
    org                           = var.org,
    app                           = var.app,
    env                           = var.env,
    fqn_host_name                 = var.fqn_host_name,
    HOST_NAME                     = var.host_name
  }

  depends_on = [  null_resource.generate_inventory_ini, module.ssh_key ]
}

# generate
resource "null_resource" "append_ssh_config" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<-EOT
      {
      echo 'Host ${var.fqn_host_name}'
      echo '    User www-data'
      echo '    HostName ${var.fqn_host_name}'
      echo '    IdentityFile "~/.ssh/.${var.org}/${var.org}-${var.app}-${var.env}-${var.host_name}-www-data.pk"'
      echo '    IdentitiesOnly yes'
      } >> ~/.ssh/config
    EOT
  }
  depends_on = [ module.ssh_key ]
}


# DO NOT REMOVE THIS COMMENT IF THERE IS A PROBLEM with KNOWN_HOSTS UCOMMENT AND USE THIS
# resource "null_resource" "update_known_hosts" {
#   triggers = {
#     instance_ip = "${data.google_compute_instance.gcp_vm.network_interface[0].access_config[0].nat_ip}"
#     fqn_host_name = var.fqn_host_name
#   }

#   provisioner "local-exec" {
#     command = <<-EOT
#       ssh-keygen -f "/home/appusr/.ssh/known_hosts" -R ${data.google_compute_instance.gcp_vm.network_interface[0].access_config[0].nat_ip} || true
#       ssh-keygen -f "/home/appusr/.ssh/known_hosts" -R "${var.fqn_host_name}" || true

#       ssh-keyscan -H ${data.google_compute_instance.gcp_vm.network_interface[0].access_config[0].nat_ip} >> /home/appusr/.ssh/known_hosts || true
#       ssh-keyscan -H "${var.fqn_host_name}" >> /home/appusr/.ssh/known_hosts || true
#     EOT
#   }

# }
