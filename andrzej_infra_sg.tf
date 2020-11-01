
####################  Public security group ##################
resource "aws_security_group" "public_sg" {
  name = "public_sg"
  description = "public_sg"
  vpc_id = aws_vpc.andrzej_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    #cidr_blocks = [var.infra_vpc_cidr]
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    #cidr_blocks = [aws_security_group.infra_elb_sg.id]
    security_groups = [aws_security_group.infra_elb_sg.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

####################  Private security group ##################
resource "aws_security_group" "private_sg" {
  name = "private_sg"
  description = "private_sg"
  vpc_id = aws_vpc.andrzej_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [aws_security_group.public_sg.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


####################  ELB security group ##################
resource "aws_security_group" "infra_elb_sg" {
  name = "infra_elb_sg"
  description = "web access to infraelb"
  vpc_id = aws_vpc.andrzej_vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}