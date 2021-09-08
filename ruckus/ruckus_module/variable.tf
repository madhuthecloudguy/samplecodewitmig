variable "subnetwork" {}

variable "project_id" {}

variable "region" {}

variable "compute_network" {}

variable "app_name" {
  description = "app_name"
  type        = string
}

variable "image" {}

variable "reserve_ip" {}

variable "ip_type" {
    description = "reserve|dynamic"
}

variable "instance_type" {}

variable "env" {}