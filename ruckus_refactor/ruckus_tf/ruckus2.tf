
module "ruckus2" {
    source = "../ruckus_module"
    env = "prod"
    app_name = "newtest1"
    subnetwork = var.subnetwork
    project_id    = var.project_id
    instance_type = "f1-micro"
    network = var.network
    image = "centos-7-v20210701"
    ip_type = "reserve" # set this to dynamic if we want to build isnatnce with dynamic ip ip_type = "dynamic"
    reserve_ip = "10.0.0.6"   #set this value to null if we want to build isnatnce with dynamic ip reserve_ip = null 
    zone = "us-central1-b"
    region = "us-central1"
    iap_ssh = "true" #set this to create firewall rule eith iap allowed iap_ssh = "true" , if iap not required iap_ssh = "false"
}


