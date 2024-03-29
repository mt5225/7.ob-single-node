data "aws_availability_zones" "available" {}

module "vpc" { #A
  source           = "../aws-base/terraform-aws-vpc"
  name             = "${var.namespace}-vpc"
  cidr             = "10.81.0.0/16"
  azs              = data.aws_availability_zones.available.names
  private_subnets  = cidrsubnets("10.81.1.0/20", 4, 4, 4)
  public_subnets   = cidrsubnets("10.81.51.0/20", 4, 4, 4)
  database_subnets = cidrsubnets("10.81.101.0/20", 4, 4, 4)

  create_database_subnet_group = true
  enable_nat_gateway           = true
  single_nat_gateway           = true
}

module "lb_sg" {
  source = "../aws-base/terraform-aws-sg"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [{
    port        = 80
    cidr_blocks = ["0.0.0.0/0"]
  }]
}

module "websvr_sg" {
  source = "../aws-base/terraform-aws-sg"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      port            = 8080
      security_groups = [module.lb_sg.security_group.id]
    },
    {
      port        = 22               #C
      cidr_blocks = ["10.81.0.0/16"] #C
    }
  ]
}

module "db_sg" {
  source = "../aws-base/terraform-aws-sg"
  vpc_id = module.vpc.vpc_id
  ingress_rules = [
    {
      port            = 2882
      security_groups = [module.websvr_sg.security_group.id]
    },
    {
      port            = 2883
      security_groups = [module.websvr_sg.security_group.id]
    },
    {
      port        = 22
      cidr_blocks = ["0.0.0.0/0"] #C
    },
  ]
}
