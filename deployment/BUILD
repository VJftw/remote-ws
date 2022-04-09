subinclude("//build/defs:terraform")

terraform_root(
    name = "deployment",
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
    opa_data = {
        "allowlist_deleted_addresses": [
            "google_compute_instance.workspace",
        ],
    },
    var_files = [
        "@third_party/repo/infrastructure//accounts/gcp:vjp-remote-ws_tfvars",
    ],
)
