subinclude("//build/defs:terraform")

terraform_module(
    name = "remote-ws-module",
    srcs = [
        "apt-get.sh",
        "dns.tf",
        "fs.sh",
        "idle-shutdown.service",
        "idle-shutdown.sh",
        "instance.tf",
        "main.tf",
        "provision-user.sh",
        "update-gcp-dns.service",
        "update-gcp-dns.sh",
        "variables.tf",
    ],
    visibility = [
        "//deployment/...",
    ],
)
