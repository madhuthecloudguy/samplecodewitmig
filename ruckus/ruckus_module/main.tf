
data "google_compute_zones" "available" {
  region = var.region
}
resource "google_compute_address" "app" {
  name         = "${var.app_name}-${var.env}-internal-ip"
  subnetwork   = var.subnetwork
  address_type = "INTERNAL"
  region       = var.region
  address      = var.reserve_ip
  count        = "${var.ip_type == "reserve" ? 1 : 0}"
}

resource "google_compute_instance" "app_reserve"  {
  count        = "${var.ip_type == "reserve" ? 1 : 0}"
  name         = "${var.app_name}-${var.env}"
  machine_type = "f1-micro"
  project      = var.project_id
  zone         = data.google_compute_zones.available.names[0]

  boot_disk {
    initialize_params {
      size  = 20
      type  = "pd-standard"
      image = var.image
    }
  }

  network_interface {
    subnetwork = var.subnetwork
    network_ip = google_compute_address.app[0].address
  }
  // Apply the firewall rule to allow health check and IAP 
  tags = [var.app_name]
}

resource "google_compute_instance" "app_dynamic"  {
  count        = "${var.ip_type == "dynamic" ? 1 : 0}"
  name         = "${var.app_name}-${var.env}"
  machine_type = var.instance_type
  project      = var.project_id
  zone         = data.google_compute_zones.available.names[0]

  boot_disk {
    initialize_params {
      size  = 20
      type  = "pd-standard"
      image = var.image
    }
  }

  network_interface {
    subnetwork = var.subnetwork
  }
  // Apply the firewall rule to allow health check and IAP 
  tags = [var.app_name]
}
