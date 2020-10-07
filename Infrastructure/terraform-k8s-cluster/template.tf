# -------------------------------------------------------------
# Templates - Exoscale
# -------------------------------------------------------------

data "exoscale_compute_template" "ubuntu" {
  zone = var.region
  name = "Linux Ubuntu 18.04 LTS 64-bit"
}