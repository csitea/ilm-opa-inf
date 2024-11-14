resource "null_resource" "generate_inventory_ini" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {

command = <<-EOT
  echo '[servers]' > ${var.proj_path}/src/terraform/${var.STEP}/inventory.${var.env}.ini
  echo '${module.gcp_compute_instance.instance_public_ip} ansible_user=debian ansible_ssh_private_key_file=/home/appusr/.ssh/.${var.org}/${var.org}-${var.app}-${var.env}-${var.host_name}.pk' >> ${var.proj_path}/src/terraform/${var.STEP}/inventory.${var.env}.ini

  echo '[local]' >> ${var.proj_path}/src/terraform/${var.STEP}/inventory.${var.env}.ini
  echo 'localhost ansible_connection=local' >> ${var.proj_path}/src/terraform/${var.STEP}/inventory.${var.env}.ini

EOT

  }
}


resource "local_file" "ansible_script" {
  content = <<-EOT
    #!/bin/bash
    # usage:
    # ${var.proj_path}/src/bash/scripts/run-ansible-${var.org}-${var.app}-${var.env}-${var.STEP}.sh

    export ANSIBLE_FORCE_COLOR=true
    export PYTHONUNBUFFERED=1

    # Adding SSH key to known hosts to avoid interaction
    ssh-keyscan -H ${module.gcp_compute_instance.instance_public_ip} >> ~/.ssh/known_hosts

    # Perform syntax check before running the playbook
    ansible-playbook --syntax-check ${var.proj_path}/src/terraform/${var.STEP}/wordpress-playbook.yaml

    # Check if the syntax check was successful
    if [ $? -eq 0 ]; then
        # Execute the playbook if syntax check passes
        nohup timeout 25m ansible-playbook ${var.proj_path}/src/terraform/${var.STEP}/wordpress-playbook.yaml \
        -i ${var.proj_path}/src/terraform/${var.STEP}/inventory.${var.env}.ini \
        --user debian \
        --private-key ${module.ssh_key.private_key_path} \
        -e ansible_python_interpreter=/usr/bin/python3 \
        -e server_ipv4=${module.gcp_compute_instance.instance_public_ip} \
        -e org=${var.org} \
        -e app=${var.app} \
        -e env=${var.env} \
        -e use_staging=${var.use_staging_ssl} \
        -e fqn_host_name="${var.fqn_host_name}" \
        -e box_domain_email=${var.box_domain_email} \
        -e db_password=${random_password.db_password.result} \
        -e db_password_root=${random_password.db_password_root.result} \
        -e wp_admin_password=${random_password.wp_admin_password.result} \
        -vvv 2>&1 | tee -a ${var.proj_path}/dat/log/ansible.${var.STEP}.${var.org}-${var.app}-${var.env}.log
    else
        echo "Syntax check failed, exiting..."
        exit 1
    fi
  EOT
  filename = "${var.proj_path}/src/bash/scripts/run-ansible-${var.org}-${var.app}-${var.env}-${var.STEP}.sh"

  depends_on = [
    module.gcp_compute_instance,
    null_resource.generate_inventory_ini,
    time_sleep.wait_50_seconds
  ]
}
