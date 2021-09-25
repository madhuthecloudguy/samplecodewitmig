variable "subnetwork" {}


variable "region" {}


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

variable "network" {
  type = object({
    qa    = string
    prod  = string
  })
}

variable "project_id" {
  type = object({
    qa    = string
    prod  = string
  })
}

variable "zone" {}

variable "iap_ssh" {}