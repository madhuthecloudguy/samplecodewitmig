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

// Replace project id of prod|qa environments accordingly
variable "project_id" {
  type = object({
    qa    = string
    prod  = string
  })
  default = {
   qa    = "prefab-grid-325306"
   prod  = "sublime-cargo-324905"
  }
}
