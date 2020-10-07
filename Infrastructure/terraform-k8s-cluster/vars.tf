# -------------------------------------------------------------
# K8S - Variables
# -------------------------------------------------------------

variable "region" {
  type        = string
  default     = "ch-dk-2"
  description = "Variable used to define where the cluster will be deployed."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Set the 'env' for the current deployment."
}