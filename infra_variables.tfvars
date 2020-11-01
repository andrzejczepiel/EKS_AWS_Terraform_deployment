#### in this file I will define variables used to manage AWS infra for andrzej account ####


# define region
region = "eu-west-1"

# define access credentials
#################################
# these are access and secret key for eks_admin user created in IAM
eks_admin_aws_access_key = ""
eks_admin_aws_secret_key = ""
andrzej_key_name = "andrzej"
andrzej_private_key_path = ""


#################################
instance_type = "t2.micro"
image_id = "ami-04facb3ed127a2eb6"
instance_name1 = "mgmt_host"


availability_zone1 = "eu-west-1a"
availability_zone2 = "eu-west-1b"
availability_zone3 = "eu-west-1c"

andrzej_vpc_cidr = "10.0.0.0/16"

andrzej_vpc_secondary_cidr = "10.1.0.0/24"


andrzej_subnet_cidr1 = "10.0.1.0/24"
andrzej_subnet_cidr2 = "10.0.2.0/24"
andrzej_subnet_cidr3 = "10.0.3.0/24"
andrzej_subnet_cidr4 = "10.0.4.0/24"
andrzej_subnet_cidr5 = "10.0.5.0/24"
andrzej_subnet_cidr6 = "10.0.6.0/24"
