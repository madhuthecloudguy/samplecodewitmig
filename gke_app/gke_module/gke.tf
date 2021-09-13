provider "google" {
  project     = var.project_id
  region      = var.region
}

resource "google_container_cluster" "gke" {
  provider                    = google-beta
  name                        = var.cluster_name
  location                    = var.region
  initial_node_count          = 1
  project                     = var.project_id
  remove_default_node_pool    = true
  enable_binary_authorization = true
  #min_master_version          = var.gke_master_version

  master_auth {
    username = ""
    password = ""
  }

  # This can't be anything except the project we live in - but it has no default
  workload_identity_config {
    identity_namespace = "${var.project_id}.svc.id.goog"
  }

  network    = var.network
  subnetwork = var.subnetwork

  #ip_allocation_policy {
  #  cluster_secondary_range_name  = "gke-pods"
  #  services_secondary_range_name = "gke-services"
  #}

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pod_subnet
    services_secondary_range_name = var.service_subnet
  }

  release_channel {
    channel = "STABLE"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.32/28"
  }

  networking_mode = "VPC_NATIVE"

  master_authorized_networks_config {
    cidr_blocks {
      display_name = "Anywhere"
      cidr_block   = "0.0.0.0/0"
    }
  }
}

resource "google_container_node_pool" "gke_primary" {
  provider   = google-beta
  name       = "gke-primary-nodepool"
  location   = var.region
  cluster    = google_container_cluster.gke.name
  project    = var.project_id
  node_count = 1

  autoscaling {
    # Minimum number of nodes in the NodePool. Must be >=0 and <= max_node_count.
    min_node_count = 1

    # Maximum number of nodes in the NodePool. Must be >= min_node_count.
    max_node_count = 3
  }

  node_config {
    preemptible  = false
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    # Can also be EXPOSE but cannot be UNSPECIFIED or SECURE without breaking WI
    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }
  }
}
