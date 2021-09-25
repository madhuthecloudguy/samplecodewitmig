provider "google" {
  project = local.project_id
  region = var.region
}

locals {
  subnetwork = "${lookup(var.subnetwork[var.env],var.region)}"
  project_id = "${var.env == "prod" ? var.project_id.prod : var.project_id.qa}"
  network = "${var.env == "prod" ? var.network.prod : var.network.qa}"
}

#data "google_compute_zones" "available" {
#  region = var.region
#}

resource "google_compute_address" "app" {
  name         = "${var.app_name}-${var.env}-internal-ip"
  subnetwork   = local.subnetwork
  address_type = "INTERNAL"
  region       = var.region
  address      = var.reserve_ip
  count        = "${var.ip_type == "reserve" ? 1 : 0}"
}

resource "google_compute_instance" "app_reserve"  {
  count        = "${var.ip_type == "reserve" ? 1 : 0}"
  name         = "${var.app_name}-${var.env}"
  machine_type = "f1-micro"
  project      = local.project_id
  #zone        = data.google_compute_zones.available.names[0]
  zone         = var.zone
  boot_disk {
    initialize_params {
      size  = 20
      type  = "pd-standard"
      image = var.image
    }
  }

  network_interface {
    subnetwork = local.subnetwork
    network_ip = google_compute_address.app[0].address
  }
  // Apply the firewall rule to allow health check and IAP 
  tags = [var.app_name]
}

resource "google_compute_instance" "app_dynamic"  {
  count        = "${var.ip_type == "dynamic" ? 1 : 0}"
  name         = "${var.app_name}-${var.env}"
  machine_type = var.instance_type
  project      = local.project_id
  #zone         = data.google_compute_zones.available.names[0]
  zone          = var.zone

  boot_disk {
    initialize_params {
      size  = 20
      type  = "pd-standard"
      image = var.image
    }
  }

  network_interface {
    subnetwork = local.subnetwork
  }
  // Apply the firewall rule to allow health check and IAP 
  tags = [var.app_name]
}

resource "google_compute_firewall" "iap_ssh" {
  count     = "${var.iap_ssh == "true" ? 1 : 0}"
  project   = local.project_id
  name      = "${var.app_name}-allow-ingress-from-iap"
  network   = local.network
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
