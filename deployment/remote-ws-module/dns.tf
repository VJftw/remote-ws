resource "google_project_service" "dns" {
  provider = google-beta

  service = "dns.googleapis.com"

  disable_dependent_services = true
}

resource "google_service_account" "remote-ws" {
  provider = google-beta

  account_id   = "${var.username}-workspace"
  display_name = local.fqn

  description = "Identity for ${local.fqn}"
}

resource "google_project_iam_member" "remote-ws-dns" {
  provider = google-beta

  project = data.google_project.project.project_id

  role   = "roles/dns.admin"
  member = "serviceAccount:${google_service_account.remote-ws.email}"
}
