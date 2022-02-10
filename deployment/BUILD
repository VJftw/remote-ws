subinclude("//build/defs:terraform")

terraform_root(
    name = "deployment",
    srcs = [
        "dns.tf",
        "idle-shutdown.service",
        "idle-shutdown.sh",
        "instance.tf",
        "main.tf",
        "provision-user.sh",
        "update-gcp-dns.service",
        "update-gcp-dns.sh",
        "variables.tf",
    ],
    var_files = [
        "@third_party/repo/infrastructure//accounts/gcp:vjp-remote-ws_tfvars",
    ],
    opa_data = {
        "allowlist_deleted_addresses": [
            "google_compute_instance.workspace",
        ],
    },
)
