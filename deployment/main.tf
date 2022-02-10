provider "google" {
  project = var.name
  region  = "europe-west2"
}

provider "google-beta" {
  project = var.name
  region  = "europe-west2"
}
