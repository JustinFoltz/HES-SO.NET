# -------------------------------------------------------------
# K8S - Master Nodes
# -------------------------------------------------------------

resource "exoscale_ipaddress" "k8s-master-ip" {
  zone                     = var.region
  description              = "Elastic IP used for masters"
  healthcheck_mode         = "http"
  healthcheck_port         = 443
  healthcheck_path         = "/"
  healthcheck_interval     = 5
  healthcheck_timeout      = 2
  healthcheck_strikes_ok   = 2
  healthcheck_strikes_fail = 3
}


resource "exoscale_compute" "master-01" {
  zone         = var.region
  display_name = "k8s-master-01"
  template_id  = data.exoscale_compute_template.ubuntu.id
  size         = "Small"
  disk_size    = 20
  key_pair     = "jgo@work"
  state        = "Running"

  affinity_groups = []
  security_groups = ["k8s-master-sg"]

  ip6 = false

  user_data = <<EOF
#cloud-config
manage_etc_hosts: k8s-master-01.jgo.sh
EOF

  tags = {
    environement = var.environment
    role         = "k8s Master"
  }

  timeouts {
    create = "60m"
    delete = "2h"
  }
}

# resource "exoscale_compute" "master-02" {
#   zone         = var.region
#   display_name = "k8s-master-02"
#   template_id  = data.exoscale_compute_template.ubuntu.id
#   size         = "Tiny"
#   disk_size    = 20
#   key_pair     = "jgo@work"
#   state        = "Running"

#   affinity_groups = []
#   security_groups = ["k8s-master-sg"]

#   ip6 = false

#   user_data = <<EOF
# #cloud-config
# manage_etc_hosts: k8s-master-02.jgo.sh
# EOF

#   tags = {
#     environement = var.environement
#     role = "k8s Master"
#   }

#   timeouts {
#     create = "60m"
#     delete = "2h"
#   }
# }