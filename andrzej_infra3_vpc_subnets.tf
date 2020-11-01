##############################################################################
##### RESORUCE SECTION #######################################################

#### VPC ################################################
resource "aws_vpc" "andrzej_vpc" {
  cidr_block = var.andrzej_vpc_cidr
  enable_dns_hostnames = "true"
  enable_dns_support = "true"
  tags = {
    Name = "andrzej_vpc"
  }
}

#resource "aws_vpc_ipv4_cidr_block_association" "vpc_secondary_cidr" {
#  vpc_id     = aws_vpc.andrzej_vpc.id
#  cidr_block = "10.1.0.0/24"
#}

#### SUBNET #############################################
resource "aws_subnet" "andrzej_subnet1" {
  vpc_id = aws_vpc.andrzej_vpc.id
  cidr_block = var.andrzej_subnet_cidr1
  map_public_ip_on_launch = "true"
  availability_zone = var.availability_zone1
  #availability_zone = data.aws_availability_zones.available.id[0]
  tags = {
    Name = "andrzej_subnet1"
    visibility = "public"
  }
}

resource "aws_subnet" "andrzej_subnet2" {
  vpc_id = aws_vpc.andrzej_vpc.id
  cidr_block = var.andrzej_subnet_cidr2
  map_public_ip_on_launch = "true"
  availability_zone = var.availability_zone2
  tags = {
    Name = "andrzej_subnet2"
    visibility = "public"
  }
}

resource "aws_subnet" "andrzej_subnet3" {
  vpc_id = aws_vpc.andrzej_vpc.id
  cidr_block = var.andrzej_subnet_cidr3
  map_public_ip_on_launch = "true"
  availability_zone = var.availability_zone3
  tags = {
    Name = "andrzej_subnet3"
    visibility = "public"
  }
}

# map_public_ip_on_launch  should be set to false for private subnets
resource "aws_subnet" "andrzej_subnet4" {
  vpc_id = aws_vpc.andrzej_vpc.id
  cidr_block = var.andrzej_subnet_cidr4
  map_public_ip_on_launch = "false"
  availability_zone = var.availability_zone1
  tags = {
    Name = "andrzej_subnet4"
    visibility = "private"
  }
}

resource "aws_subnet" "andrzej_subnet5" {
  vpc_id = aws_vpc.andrzej_vpc.id
  cidr_block = var.andrzej_subnet_cidr5
  map_public_ip_on_launch = "false"
  availability_zone = var.availability_zone2
  tags = {
    Name = "andrzej_subnet5"
    visibility = "private"
  }
}

resource "aws_subnet" "andrzej_subnet6" {
  vpc_id = aws_vpc.andrzej_vpc.id
  cidr_block = var.andrzej_subnet_cidr6
  map_public_ip_on_launch = "false"
  availability_zone = var.availability_zone3
  tags = {
    Name = "andrzej_subnet6"
    visibility = "private"
  }
}

#### INTERNET GATEWAY ###################################
resource "aws_internet_gateway" "andrzej_igw" {
    vpc_id = aws_vpc.andrzej_vpc.id
    tags = {
      Name = "andrzej_igw"
  }
}

#### EIP FOR NAT GATEWAY ########################################
resource "aws_eip" "andrzej_nat_gw_eip" {
  vpc = true
}


#### NAT GATEWAY ########################################
resource "aws_nat_gateway" "andrzej_nat_gw" {
  allocation_id = aws_eip.andrzej_nat_gw_eip.id
  subnet_id     = aws_subnet.andrzej_subnet1.id
  depends_on = [aws_eip.andrzej_nat_gw_eip]
  tags = {
    Name = "andrzej_nat_gw"
  }
}


### ELastic Network Interface ################################
#resource "aws_network_interface" "web-ENI" {
#  subnet_id       = aws_subnet.andrzej_subnet4.id

#  attachment {
#    instance     = aws_instance.web2.id
#    device_index = 1
#  }
#}

#### PUBLIC ROUTE TABLE ########################################
resource "aws_route_table" "andrzej_public_route_table" {
  vpc_id = aws_vpc.andrzej_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.andrzej_igw.id
  }
  tags = {
    Name = "andrzej_public_route_table"
  }
}


#### PRIVATE ROUTE TABLE ########################################
resource "aws_route_table" "andrzej_private_route_table" {
  vpc_id = aws_vpc.andrzej_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.andrzej_nat_gw.id
  }
  tags = {
    Name = "andrzej_private_route_table"
  }
}

##### public associations #########################################
resource "aws_route_table_association" "route_table_andrzej_subnet1_association" {
  subnet_id      = aws_subnet.andrzej_subnet1.id
  route_table_id = aws_route_table.andrzej_public_route_table.id
}

resource "aws_route_table_association" "route_table_andrzej_subnet2_association" {
  subnet_id      = aws_subnet.andrzej_subnet2.id
  route_table_id = aws_route_table.andrzej_public_route_table.id
}

resource "aws_route_table_association" "route_table_andrzej_subnet3_association" {
  subnet_id      = aws_subnet.andrzej_subnet3.id
  route_table_id = aws_route_table.andrzej_public_route_table.id
}

##### private associations #########################################
resource "aws_route_table_association" "route_table_andrzej_subnet4_association" {
  subnet_id      = aws_subnet.andrzej_subnet4.id
  route_table_id = aws_route_table.andrzej_private_route_table.id
}

resource "aws_route_table_association" "route_table_andrzej_subnet5_association" {
  subnet_id      = aws_subnet.andrzej_subnet5.id
  route_table_id = aws_route_table.andrzej_private_route_table.id
}

resource "aws_route_table_association" "route_table_andrzej_subnet6_association" {
  subnet_id      = aws_subnet.andrzej_subnet6.id
  route_table_id = aws_route_table.andrzej_private_route_table.id
}



