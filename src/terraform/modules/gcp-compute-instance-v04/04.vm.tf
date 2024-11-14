locals {
  vm_full_name = "${var.org}-${var.app}-${var.env}-${var.host_name}"
}

resource "google_compute_instance" "virtual_machine" {
  name         = "${local.vm_full_name}-vm"
  machine_type = var.machine_type
  tags         = var.instance_tags

  boot_disk {
    initialize_params {
      image = var.machine_image              # Name of the image, e.g. "debian-cloud/debian-12"
      size  = var.google_compute_boot_disk_size  # Size of the boot disk in GB
      type  = "pd-ssd"                       # Ensure that the boot disk is created as an SSD
    }
  }

  attached_disk {
    source      = google_compute_disk.disk.id
    device_name = google_compute_disk.disk.name
  }

  network_interface {
    network = var.network  # Name of the network, e.g. "default"

    access_config {
      # Ephemeral IP
    }
  }

  service_account {
    email  = google_service_account.sa_compute_instance.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  # Optional: Metadata for the instance
  metadata = {
    # GOTCHA !!! this usr CANNOT be root !!! Because of GCP /etc/sshd_config default settings
    "ssh-keys" = "${var.user}:${trimspace(var.tls_private_key.public_key_openssh)}"
  }

  labels = {
    org         = var.org
    app         = var.app
    env         = var.env
    gcp_project = var.gcp_project
    module      = "gcp-compute-instance-v03"
    name        = "${local.vm_full_name}-vm"
  }
}

# Volume for the VM
resource "google_compute_disk" "disk" {
  name = "${local.vm_full_name}-vm-disk-data"
  type = var.disk_type
  size = var.disk_size

  labels = {
    org         = var.org
    app         = var.app
    env         = var.env
    gcp_project = var.gcp_project
    module      = "gcp-compute-instance-v04"
    name        = "${local.vm_full_name}-vm-disk-data"
    disk_size   = var.disk_size
    disk_type   = var.disk_type
  }
}
