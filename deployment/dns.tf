data "google_dns_managed_zone" "dns" {
  project = "vjp-dns"
  name    = "vjp-dns"
}

resource "google_project_service" "dns" {
  provider = google-beta

  service = "dns.googleapis.com"

  disable_dependent_services = true
}


resource "google_dns_record_set" "remote-ws" {
  name = "remote-ws.${data.google_dns_managed_zone.dns.dns_name}"
  type = "A"
  ttl  = 60

  managed_zone = data.google_dns_managed_zone.dns.name

  rrdatas = [google_compute_instance.workspace.network_interface[0].access_config[0].nat_ip]
}

resource "google_service_account" "remote-ws" {
  account_id   = "remote-ws"
  display_name = "remote-ws"

  description = "Remote WS identity"
}

resource "google_project_iam_member" "remote-ws-dns" {
  project = "vjp-dns"

  role   = "roles/dns.admin"
  member = "serviceAccount:${google_service_account.remote-ws.email}"
}
