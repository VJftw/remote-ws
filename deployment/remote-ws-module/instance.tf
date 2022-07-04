resource "google_compute_instance" "workspace" {
  provider = google-beta

  name         = local.cleaned_fqn
  machine_type = var.machine_type
  zone         = var.zone

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
    network = var.network_self_link

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

  metadata = {
    "enable-oslogin" = "TRUE"
  }

  metadata_startup_script = <<EOF
#!/usr/bin/env bash
set -euo pipefail

echo "${filebase64("${path.module}/apt-get.sh")}" | base64 -d - > /usr/local/bin/apt-get
chmod +x /usr/local/bin/apt-get

cat <<EOC > /var/update-gcp-dns.env
ZONE_PROJECT="${data.google_project.project.project_id}"
DOMAIN="${var.username}.${var.hosted_zone_dns_name}"
ZONE_NAME="${var.hosted_zone_name}"
EOC
chmod 0600 /var/update-gcp-dns.env
chown root:root /var/update-gcp-dns.env

echo "${filebase64("${path.module}/update-gcp-dns.sh")}" | base64 -d - > /usr/local/bin/update-gcp-dns
chmod +x /usr/local/bin/update-gcp-dns
echo "${filebase64("${path.module}/update-gcp-dns.service")}" | base64 -d - > /etc/systemd/system/update-gcp-dns.service
/usr/bin/systemctl daemon-reload
/usr/bin/systemctl enable update-gcp-dns
/usr/bin/systemctl start update-gcp-dns

echo "${filebase64("${path.module}/idle-shutdown.sh")}" | base64 -d - > /usr/local/bin/idle-shutdown
chmod +x /usr/local/bin/idle-shutdown
echo "${filebase64("${path.module}/idle-shutdown.service")}" | base64 -d - > /etc/systemd/system/idle-shutdown.service
/usr/bin/systemctl daemon-reload
/usr/bin/systemctl enable idle-shutdown
/usr/bin/systemctl start idle-shutdown

echo "${filebase64("${path.module}/provision-user.sh")}" | base64 -d - > /etc/provision-user.sh
chmod +x /etc/provision-user.sh
/etc/provision-user.sh "${var.username}" "${base64encode(join("\n", var.ssh_public_keys))}"

echo "${filebase64("${path.module}/fs.sh")}" | base64 -d - > /etc/fs.sh
chmod +x /etc/fs.sh
/etc/fs.sh
EOF
}

resource "google_compute_disk" "root" {
  provider = google-beta

  name  = "${local.cleaned_fqn}-root"
  type  = "pd-ssd"
  zone  = var.zone
  size  = 10
  image = "ubuntu-minimal-2004-focal-v20220203"
}

resource "google_compute_disk" "home" {
  provider = google-beta

  name = "${local.cleaned_fqn}-home"
  type = "pd-balanced"
  zone = var.zone
  size = 80
}

resource "google_compute_resource_policy" "workspace" {
  provider = google-beta

  name   = local.cleaned_fqn
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
