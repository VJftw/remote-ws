provider "google-beta" {
  project = "vjp-remote-ws"
  region  = "europe-west2"
}

module "vjftw" {
  source = "//deployment/remote-ws-module:remote-ws-module"

  hosted_zone_name     = data.google_dns_managed_zone.workspaces.name
  hosted_zone_dns_name = data.google_dns_managed_zone.workspaces.dns_name
  network_self_link    = google_compute_network.workspace.self_link

  username = "vjftw"
  ssh_public_keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAAd2c9cCa12ozaNjeEjTShxj92oMyiwiiIQ+5buXj2D vj@SIRIUS",
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP9RT6lp86XpwrC8R7jFfnm3DV+PAVNP2Rbt7YjX6tJE vj@DUMBLEDORE",
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM4Y2QHqM1KAmXAyxtS61gSMeum27slKZCGaSXS6/LRb vj@vjpatel.me"
  ]

  machine_type = "n2d-standard-8"
  zone         = "europe-west2-c"
}
