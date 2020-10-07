# -------------------------------------------------------------
# K8S - Utils - NFS, Registry etc...
# -------------------------------------------------------------
resource "exoscale_compute" "k8s-nfs-01" {
  zone         = var.region
  display_name = "k8s-nfs-01"
  template_id  = data.exoscale_compute_template.ubuntu.id
  size         = "Tiny"
  disk_size    = 20
  key_pair     = "jgo@work"
  state        = "Running"

  affinity_groups = []
  security_groups = ["k8s-utils-sg"]

  ip6 = false

  user_data = <<EOF
#cloud-config
manage_etc_hosts: k8s-nfs-01.jgo.sh
EOF

  tags = {
    environement = var.environment
    role         = "k8s NFS"
  }

  timeouts {
    create = "60m"
    delete = "2h"
  }
}