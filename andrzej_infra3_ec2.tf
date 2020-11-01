#### EC2 INSTANCE #######################################

resource "aws_instance" "mgmt_host" {
  ami = var.image_id
  key_name = var.andrzej_key_name
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  subnet_id = aws_subnet.andrzej_subnet1.id

  connection {
    type = "ssh"
    host = self.public_ip
    user = "ec2-user"
    private_key = file(var.andrzej_private_key_path)
  }
  
# additional tools on mgmt_host  
  provisioner "remote-exec" {
    inline = [
      "sudo yum install telnet -y",
      "sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo",
      "sudo dnf install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm -y",
      "sudo dnf install docker-ce-3:19.03.8-3.el7 -y",
      "sudo yum install python3-pip.noarch -y",
      "sudo pip3.6 install docker-compose",
      "sudo yum install unzip -y",
      "sudo yum install gzip -y",
      "sudo yum install dos2unix.x86_64 -y",
      "sudo yum install git.x86_64 -y",
      "sudo service docker start",
      "sudo adduser andrzej",
      "sudo usermod -aG docker andrzej",
      "sudo adduser kube_user",
      "sudo usermod -aG docker kube_user",
      "sudo docker pull httpd",
      "sudo docker pull nginx",
      "sudo yum install wget -y",
      
      "sudo curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip",
      "sudo unzip awscliv2.zip",
      "sudo ./aws/install", 
      "sudo curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/aws-iam-authenticator",
      "sudo curl -o aws-iam-authenticator.sha256 https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/aws-iam-authenticator.sha256",
      "sudo chmod +x ./aws-iam-authenticator",
      "sudo cp aws-iam-authenticator /usr/local/bin/"
    ]
  }

    tags = {
    Name = var.instance_name1
  }
}
