subinclude("//build/defs:terraform")

terraform_root(
    name = "deployment",
    srcs = [
        "dns.tf",
        "main.tf",
        "network.tf",
    ],
    modules = [
        "//deployment/remote-ws-module:remote-ws-module",
    ],
    opa_data = {
        "allowlist_deleted_addresses": [
            "module.vjftw.google_compute_instance.workspace",
        ],
    },
    var_files = [
        "@third_party/repo/infrastructure//accounts/gcp:vjp-remote-ws_tfvars",
    ],
)

# re-import
"""

terraform init

terraform import module.vjftw.google_service_account.remote-ws "projects/vjp-remote-ws/serviceAccounts/vjftw-workspace@vjp-remote-ws.iam.gserviceaccount.com"
terraform import module.vjftw.google_project_service.dns "vjp-remote-ws/dns.googleapis.com"
terraform import module.vjftw.google_compute_resource_policy.workspace "projects/vjp-remote-ws/regions/europe-west2/resourcePolicies/vjftw-workspaces-gcp-vjpatel-me"
terraform import google_compute_network.workspace "projects/vjp-remote-ws/global/networks/workspaces-gcp-vjpatel-me"
terraform import module.vjftw.google_compute_instance.workspace "projects/vjp-remote-ws/zones/europe-west2-c/instances/vjftw-workspaces-gcp-vjpatel-me"
terraform import google_compute_firewall.workspace "projects/vjp-remote-ws/global/firewalls/workspace-ssh-ingress"
terraform import module.vjftw.google_compute_disk.root "projects/vjp-remote-ws/zones/europe-west2-c/disks/vjftw-workspaces-gcp-vjpatel-me-root"
terraform import module.vjftw.google_compute_disk.home "projects/vjp-remote-ws/zones/europe-west2-c/disks/vjftw-workspaces-gcp-vjpatel-me-home"

"""
