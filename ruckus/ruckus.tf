provider "google" {
  project     = "${var.env == "prod" ? var.prod_project_id : var.qa_project_id}"
  region      = var.region
}

variable "env" {
    type = string
    description = "qa|prod"
    default = "prod"
}

variable "region" {
  type = string
  description = "region to deploy instance"
  default = "us-east1"
}

// Replace subnet details of prod|qa environments accordingly
variable "subnetwork" {
  default = {
    prod = {
      us-east1 = "projects/sublime-cargo-324905/regions/us-east1/subnetworks/subnet2",
      us-central1 = "projects/sublime-cargo-324905/regions/us-central1/subnetworks/subnet1"
    }

    qa = {
      us-east1 = "projects/prefab-grid-325306/regions/us-east1/subnetworks/subnet1",
      us-central1 = "projects/prefab-grid-325306/regions/us-central1/subnetworks/subnet2"
    }
  }
}

// Replace VPC network details of prod|qa environments accordingly
variable "network" {
  type = object({
    qa    = string
    prod  = string
  })
  default = {
   qa    = "projects/prefab-grid-325306/global/networks/vpc1"
   prod  = "projects/sublime-cargo-324905/global/networks/vpc1" 
  }
}

variable "app_name" {
  type = string
  default = "test"
}

variable  "prod_project_id" {
 type = string
 default = "sublime-cargo-324905"
}

variable  "qa_project_id" {
 type = string
 default = "prefab-grid-325306"
}

module "ruckus" {
    source = "./ruckus_module"
    env = var.env
    subnetwork = "${lookup(var.subnetwork[var.env],var.region)}"
    project_id    = "${var.env == "prod" ? var.prod_project_id : var.qa_project_id}"
    region      = var.region
    compute_network = "${var.env == "prod" ? var.network.prod : var.network.qa}"
    instance_type = "f1-micro"
    app_name = var.app_name
    image = "centos-7-v20210701"
    ip_type = "reserve" # set this to dynamic if we want to build isnatnce with dynamic ip ip_type = "dynamic"
    reserve_ip = "10.0.1.9"   #set this value to null if we want to build isnatnce with dynamic ip reserve_ip = null 
}

resource "google_compute_firewall" "iap_ssh" {
  project   = "${var.env == "prod" ? var.prod_project_id : var.qa_project_id}"
  name      = "${var.app_name}-allow-ingress-from-iap"
  network   = "${var.env == "prod" ? var.network.prod : var.network.qa}"
  priority  = 1001
  direction = "INGRESS"
  source_ranges = [
    "35.235.240.0/20"
  ]
  target_tags = [var.app_name]
  allow {
    protocol = "tcp"
    ports    = [22]
  }
}

