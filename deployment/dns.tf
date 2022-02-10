resource "google_project_service" "dns" {
  provider = google-beta

  service = "dns.googleapis.com"

  disable_dependent_services = true
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
