terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.5.0"
    }
  }
}

locals {
  fqn = "${var.username}.${trimsuffix(var.hosted_zone_dns_name, ".")}"
  cleaned_fqn = replace(local.fqn, "/[._]/", "-")
}

data "google_project" "project" {
  provider =  google-beta
}
