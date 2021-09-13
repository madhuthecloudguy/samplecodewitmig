module "gke" {
    source = "./gke_module"
    project_id = "sublime-cargo-324905"
    cluster_name = "test"
    region = "us-central1"
    network = "projects/sublime-cargo-324905/global/networks/vpc1"
    subnetwork = "projects/sublime-cargo-324905/regions/us-central1/subnetworks/subnet1"
    pod_subnet = "pod-subnet"
    service_subnet = "service-subnet"
}