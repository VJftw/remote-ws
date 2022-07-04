data "google_dns_managed_zone" "workspaces" {
  provider = google-beta

  name = "workspaces"
}
