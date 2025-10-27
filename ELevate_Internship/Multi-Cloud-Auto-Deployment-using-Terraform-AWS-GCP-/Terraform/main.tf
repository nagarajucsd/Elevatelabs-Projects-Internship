resource "aws_instance" "aws_web" {
  ami           = "ami-0360c520857e3138f" # Ubuntu 22.04 (us-east-1)
  instance_type = var.instance_type

  tags = {
    Name = "aws-nginx-server"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y nginx
              systemctl start nginx
              EOF
}

##############

# Reserve a Static Public IP
############################
resource "google_compute_address" "static_ip" {
  name   = "gcp-static-ip"
  region = "us-central1"
}

############################
# Firewall Rule (Allow SSH + HTTP)
############################
resource "google_compute_firewall" "allow_http_ssh" {
  name    = "allow-http-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

############################
# GCP VM with Ubuntu + NGINX
############################
resource "google_compute_instance" "gcp_web" {
  name         = "gcp-nginx-server"
  machine_type = var.gcp_machine_type
  zone         = "us-central1-a"

  tags = ["http-server"]

 boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"

    # Attach Reserved Static IP
    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }
metadata_startup_script = file("startup.sh")
}
