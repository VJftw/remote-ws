resource "google_compute_network" "workspace" {
  provider = google-beta

  name         = replace(trimsuffix(data.google_dns_managed_zone.workspaces.dns_name, "."), ".", "-")
  description  = "VPC for remote workspaces in ${data.google_dns_managed_zone.workspaces.dns_name}"
  routing_mode = "REGIONAL"
}

resource "google_compute_firewall" "workspace" {
  provider = google-beta

  name    = "workspace-ssh-ingress"
  network = google_compute_network.workspace.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}
