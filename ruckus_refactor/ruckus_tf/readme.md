update ruckus.tf file as below 
we can create multiple files with below configuration but change file name and module logical name


Note: # change module logical name when creating multiple files by calling ruckus_module
      # update variable.tf under ruckus_tf folder only once for project ids and network and subnetwork details
      # dont chnage anything under ruckus_module folder 
      




module "ruckus" {   
    source = "../ruckus_module"
    env = "prod"                  # environment name qa|prod
    app_name = "new"              # app name
    subnetwork = var.subnetwork
    project_id    = var.project_id
    instance_type = "f1-micro"     # update machine type accordingly
    network = var.network
    image = "centos-7-v20210701"   # update machine image accordingly
    ip_type = "reserve"            # set this to dynamic if we want to build isnatnce with dynamic ip ip_type = "dynamic"
    reserve_ip = "10.0.1.9"        # set this value to null if we want to build isnatnce with dynamic ip reserve_ip = null 
    zone = "us-east1-b"            # region in which resourse need to create
    region = "us-east1"            # GCE instance zone
    iap_ssh = "true"               # set this to create firewall rule eith iap allowed iap_ssh = "true" , if iap not required iap_ssh = "false"
}









