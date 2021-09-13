variable "cluster_name" {}

variable "region" {}

variable "project_id" {}

variable "network" {}

variable "subnetwork" {}

variable "pod_subnet" {
    description = "secondary range in cluster network to assign pod ip's"
}

variable "service_subnet" {
    description = "secondary range in cluster network to assign service Ip"
}