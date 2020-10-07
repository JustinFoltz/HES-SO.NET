# -------------------------------------------------------------
# Providers
# -------------------------------------------------------------

provider "exoscale" {
  version = "~> 0.15"

  config = "secrets/cloudstack.ini"
  region = "cloudstack"
}
