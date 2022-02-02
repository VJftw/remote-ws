data "google_dns_managed_zone" "dns" {
  project = "vjp-dns"
  name    = "vjp-dns"
}

resource "google_dns_record_set" "remote-ws" {
  name = "remote-ws.${data.google_dns_managed_zone.dns.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = data.google_dns_managed_zone.dns.name

  rrdatas = [google_compute_instance.workspace.network_interface[0].access_config[0].nat_ip]
}
