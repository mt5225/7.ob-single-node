module "obsvr" {
  source      = "./modules/ob"        #A
  namespace   = var.namespace         #B
  ssh_keypair = var.ssh_keypair       #A
  vpc         = module.networking.vpc #A
  sg          = module.networking.sg  #A

}

module "networking" {
  source    = "./modules/networking" #A
  namespace = var.namespace          #B
}

resource "ansible_host" "obsvr" {
  inventory_hostname = module.obsvr.public_ip
  groups             = ["obsvr"]
  vars = {
    ansible_user = "centos"
  }
}
