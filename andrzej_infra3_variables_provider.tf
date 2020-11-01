##############################################################################
#### VARIABLE SECTION ########################################################
variable "eks_admin_aws_access_key" {}
variable "eks_admin_aws_secret_key" {}
variable "andrzej_key_name" {}
variable "andrzej_private_key_path" {}

variable "instance_type" {}
variable "image_id" {}

variable "instance_name1" {}

variable "region" {
  default = "eu-west-1"
}
variable "availability_zone1" {}
variable "availability_zone2" {}
variable "availability_zone3" {}

variable "andrzej_vpc_cidr" {}
variable "andrzej_vpc_secondary_cidr" {}

variable "andrzej_subnet_cidr1" {}
variable "andrzej_subnet_cidr2" {}
variable "andrzej_subnet_cidr3" {}
variable "andrzej_subnet_cidr4" {}
variable "andrzej_subnet_cidr5" {}
variable "andrzej_subnet_cidr6" {}

##############################################################################
####  PROVIDER SECTION #######################################################
provider "aws" {
  region  = var.region
  access_key = var.eks_admin_aws_access_key
  secret_key = var.eks_admin_aws_secret_key
  version = "~> 2.49"
}






