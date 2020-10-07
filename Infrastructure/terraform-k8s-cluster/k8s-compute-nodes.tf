# -------------------------------------------------------------
# K8S - Worker Nodes
# -------------------------------------------------------------
resource "exoscale_compute" "worker-01" {
  zone         = var.region
  display_name = "k8s-worker-01"
  template_id  = data.exoscale_compute_template.ubuntu.id
  size         = "Medium"
  disk_size    = 20
  key_pair     = "jgo@work"
  state        = "Running"

  affinity_groups = []
  security_groups = ["k8s-worker-sg"]

  ip6 = false

  user_data = <<EOF
#cloud-config
manage_etc_hosts: k8s-worker-01.jgo.sh
EOF

  tags = {
    environement = var.environment
    role         = "k8s Worker"
  }

  timeouts {
    create = "60m"
    delete = "2h"
  }
}

resource "exoscale_compute" "worker-02" {
  zone         = var.region
  display_name = "k8s-worker-02"
  template_id  = data.exoscale_compute_template.ubuntu.id
  size         = "Medium"
  disk_size    = 20
  key_pair     = "jgo@work"
  state        = "Running"

  affinity_groups = []
  security_groups = ["k8s-worker-sg"]

  ip6 = false

  user_data = <<EOF
#cloud-config
manage_etc_hosts: k8s-worker-02.jgo.sh
EOF

  tags = {
    environement = var.environment
    role         = "k8s Worker"
  }

  timeouts {
    create = "60m"
    delete = "2h"
  }
}

resource "exoscale_compute" "master-03" {
  zone         = var.region
  display_name = "k8s-worker-03"
  template_id  = data.exoscale_compute_template.ubuntu.id
  size         = "Medium"
  disk_size    = 20
  key_pair     = "jgo@work"
  state        = "Running"

  affinity_groups = []
  security_groups = ["k8s-worker-sg"]

  ip6 = false

  user_data = <<EOF
#cloud-config
manage_etc_hosts: k8s-worker-03.jgo.sh
EOF

  tags = {
    environement = var.environment
    role         = "k8s Worker"
  }

  timeouts {
    create = "60m"
    delete = "2h"
  }
}