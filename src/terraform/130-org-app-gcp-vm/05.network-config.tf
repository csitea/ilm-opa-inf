resource "google_compute_firewall" "allow_ssh_from_anywhere" {
  name    = "allow-ssh-from-anywhere-${var.org}-${var.app}-${var.env}"
  network = "default"
  target_tags = ["allow-ssh-from-anywhere-${var.org}-${var.app}-${var.env}"]

  allow {
    protocol = "tcp"
    ports    = ["22"] # Allow SSH traffic
  }

  source_ranges = ["0.0.0.0/0"] # Allow traffic from any IP address
}

resource "google_compute_firewall" "allow_ssh_iap" {
  name    = "allow-ssh-iap-${var.org}-${var.app}-${var.env}"
  network = "default"
  target_tags = ["allow-ssh-iap-${var.org}-${var.app}-${var.env}"]

  allow {
    protocol = "tcp"
    ports    = ["22"] # Allow SSH traffic
  }

  source_ranges = ["35.235.240.0/20"] # Allow traffic from IAP IP range
}

resource "google_compute_firewall" "allow_http_protocols" {
  name    = "allow-https-${var.org}-${var.app}-${var.env}"
  network = "default"
  target_tags = ["allow-https-${var.org}-${var.app}-${var.env}"]

  allow {
    protocol = "tcp"
    ports    = ["80","8080","8443","443"]
  }

  source_ranges = ["0.0.0.0/0"] # Allow HTTP/HTTPS from any IP address
}
