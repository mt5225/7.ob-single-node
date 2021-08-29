module "iam_instance_profile" {
  source  = "../aws-base/terraform-aws-iip"
  actions = ["logs:*", "rds:*"]
}

module "ob" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "3.1.0"
  name                        = "${var.namespace}-ec2"
  ami                         = data.aws_ami.centos.id
  instance_type               = "t3.xlarge"
  key_name                    = var.ssh_keypair
  vpc_security_group_ids      = [var.sg.db]
  subnet_id                   = var.vpc.public_subnets[0]
  iam_instance_profile        = module.iam_instance_profile.name
  associate_public_ip_address = true

  tags = {
    Terraform   = "true"
    Environment = "demo"
  }
}

