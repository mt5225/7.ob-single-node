variable "namespace" {
  description = "The project namespace to use for unique resource naming"
  type        = string
  default     = "obsingle"
}

variable "ssh_keypair" {
  description = "SSH keypair to use for EC2 instance"
  default     = "ansible" #A
  type        = string
}

variable "region" {
  description = "AWS region"
  default     = "us-west-2"
  type        = string
}
