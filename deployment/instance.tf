resource "google_compute_instance" "workspace" {
  name         = "remote-ws"
  machine_type = "n2d-standard-4"
  zone         = "europe-west2-c"

  scheduling {
    preemptible         = true
    on_host_maintenance = "TERMINATE"
    automatic_restart   = false
  }

  # deletion_protection = true

  boot_disk {
    auto_delete = true
    source      = google_compute_disk.root.self_link
  }

  attached_disk {
    device_name = "home"
    source      = google_compute_disk.home.self_link
  }

  network_interface {
    network = google_compute_network.workspace.self_link

    access_config {
      // Ephemeral IP
    }
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = false
  }

  service_account {
    email  = google_service_account.remote-ws.email
    scopes = ["cloud-platform"]
  }

  metadata_startup_script = <<EOF
#!/bin/bash
set -euo pipefail

cat <<EOC > /var/update-gcp-dns.env
DOMAIN="remote-ws.gcp.vjpatel.me"
ZONE_PROJECT="vjp-dns"
ZONE_NAME="vjp-dns"
EOC
chmod 0600 /var/update-gcp-dns.env
chown root:root /var/update-gcp-dns.env

echo "${filebase64("update-gcp-dns.sh")}" | base64 -d - > /usr/local/bin/update-gcp-dns
chmod +x /usr/local/bin/update-gcp-dns
echo "${filebase64("update-gcp-dns.service")}" | base64 -d - > /etc/systemd/system/update-gcp-dns.service
/usr/bin/systemctl daemon-reload
/usr/bin/systemctl enable update-gcp-dns
/usr/bin/systemctl start update-gcp-dns

echo "${filebase64("idle-shutdown.sh")}" | base64 -d - > /usr/local/bin/idle-shutdown
chmod +x /usr/local/bin/idle-shutdown
echo "${filebase64("idle-shutdown.service")}" | base64 -d - > /etc/systemd/system/idle-shutdown.service
/usr/bin/systemctl daemon-reload
/usr/bin/systemctl enable idle-shutdown
/usr/bin/systemctl start idle-shutdown

echo "${filebase64("provision-user.sh")}" | base64 -d - > /etc/provision-user.sh
chmod +x /etc/provision-user.sh
/etc/provision-user.sh
EOF
}

resource "google_compute_disk" "root" {
  name  = "remote-ws-vjpatel-me-root"
  type  = "pd-ssd"
  zone  = "europe-west2-c"
  size  = 10
  image = "ubuntu-minimal-2004-focal-v20220203"
}

resource "google_compute_disk" "home" {
  name = "remote-ws-vjpatel-me-home"
  type = "pd-balanced"
  zone = "europe-west2-c"
  size = 80
}

resource "google_compute_resource_policy" "workspace" {
  name   = "workspace"
  region = "europe-west2"
  snapshot_schedule_policy {
    schedule {
      hourly_schedule {
        hours_in_cycle = 23
        start_time     = "06:00"
      }
    }
    retention_policy {
      max_retention_days    = 7
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }
  }
}

resource "google_compute_network" "workspace" {
  name         = "workspace"
  description  = "VPC for remote workspaces"
  routing_mode = "REGIONAL"
}

resource "google_compute_firewall" "workspace" {
  name    = "workspace"
  network = google_compute_network.workspace.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}
