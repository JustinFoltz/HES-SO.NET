# -------------------------------------------------------------
# K8S - Security Groups Rules
# -------------------------------------------------------------

resource "exoscale_security_group" "k8s-master-sg" {
  name        = "k8s-master-sg"
  description = "K8S - Cluster"
}

resource "exoscale_security_group" "k8s-worker-sg" {
  name        = "k8s-worker-sg"
  description = "K8S - Cluster"
}

resource "exoscale_security_group" "k8s-utils-sg" {
  name        = "k8s-utils-sg"
  description = "K8S - Utils"
}

# ------------------------------
# Master SG
# ------------------------------
resource "exoscale_security_group_rule" "k8s-internal-traffic" {
  security_group_id   = exoscale_security_group.k8s-master-sg.id
  type                = "INGRESS"
  protocol            = "TCP"
  user_security_group = exoscale_security_group.k8s-worker-sg.name # "::/0" for IPv6
  start_port          = 0
  end_port            = 65535
}

resource "exoscale_security_group_rule" "ssh" {
  security_group_id = exoscale_security_group.k8s-master-sg.id
  type              = "INGRESS"
  protocol          = "TCP"
  cidr              = "0.0.0.0/0" # "::/0" for IPv6
  start_port        = 22
  end_port          = 22
}

resource "exoscale_security_group_rule" "http" {
  security_group_id = exoscale_security_group.k8s-master-sg.id
  type              = "INGRESS"
  protocol          = "TCP"
  cidr              = "0.0.0.0/0" # "::/0" for IPv6
  start_port        = 80
  end_port          = 80
}

resource "exoscale_security_group_rule" "https" {
  security_group_id = exoscale_security_group.k8s-master-sg.id
  type              = "INGRESS"
  protocol          = "TCP"
  cidr              = "0.0.0.0/0" # "::/0" for IPv6
  start_port        = 443
  end_port          = 443
}

resource "exoscale_security_group_rule" "k8s-admin" {
  security_group_id = exoscale_security_group.k8s-master-sg.id
  type              = "INGRESS"
  protocol          = "TCP"
  cidr              = "0.0.0.0/0" # "::/0" for IPv6
  start_port        = 6443
  end_port          = 6443
}
# ------------------------------
# Worker SG
# ------------------------------

resource "exoscale_security_group_rule" "k8s-worker-int-traffic" {
  security_group_id   = exoscale_security_group.k8s-worker-sg.id
  type                = "INGRESS"
  protocol            = "TCP"
  user_security_group = exoscale_security_group.k8s-master-sg.name # "::/0" for IPv6
  start_port          = 0
  end_port            = 65535
}

resource "exoscale_security_group_rule" "k8s-worker-utils-traffic" {
  security_group_id   = exoscale_security_group.k8s-worker-sg.id
  type                = "INGRESS"
  protocol            = "TCP"
  user_security_group = exoscale_security_group.k8s-utils-sg.name # "::/0" for IPv6
  start_port          = 0
  end_port            = 65535
}

resource "exoscale_security_group_rule" "worker-ssh" {
  security_group_id = exoscale_security_group.k8s-worker-sg.id
  type              = "INGRESS"
  protocol          = "TCP"
  cidr              = "0.0.0.0/0" # "::/0" for IPv6
  start_port        = 22
  end_port          = 22
}

# ------------------------------
# K8S utils SG
# ------------------------------
resource "exoscale_security_group_rule" "k8s-utils-traffic" {
  security_group_id   = exoscale_security_group.k8s-utils-sg.id
  type                = "INGRESS"
  protocol            = "TCP"
  user_security_group = exoscale_security_group.k8s-worker-sg.name # "::/0" for IPv6
  start_port          = 0
  end_port            = 65535
}

resource "exoscale_security_group_rule" "k8s-utils-registry-https" {
  security_group_id = exoscale_security_group.k8s-utils-sg.id
  type              = "INGRESS"
  protocol          = "TCP"
  cidr              = "0.0.0.0/0" # "::/0" for IPv6
  start_port        = 443
  end_port          = 443
}

resource "exoscale_security_group_rule" "k8s-utils-ssh" {
  security_group_id = exoscale_security_group.k8s-utils-sg.id
  type              = "INGRESS"
  protocol          = "TCP"
  cidr              = "0.0.0.0/0" # "::/0" for IPv6
  start_port        = 22
  end_port          = 22
}
