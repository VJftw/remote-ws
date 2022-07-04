variable "hosted_zone_name" {
  type = string
  description = "The GCP hosted zone name to provision instances under."
}

variable "hosted_zone_dns_name" {
  type = string
  description = "The GCP hosted zone DNS name to provision instances under."
}

variable "network_self_link" {
  type = string
  description = "The GCP network self link to provision instances in."
}


variable "username" {
  type = string
  description = "The name of the user to provision on the instance."
}

variable "ssh_public_keys" {
  type = list(string)
  description = "A list of SSH public keys to accept for the username."
  default = []
}

variable "machine_type" {
  type = string
  description = "The type of machine."
  default = "n2d-standard-4"
}

variable "zone" {
  type = string
  description = "The zone to launch instances in."
  default = "europe-west2-c"
}
