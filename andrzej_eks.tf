############################################################################
# creating EKS IAM ROLE
resource "aws_iam_role" "andrzej_eks_cluster_iam_role" {
  name = "andrzej_eks_cluster_iam_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

## attached EKS IAM policies to above created role andrzej_eks_cluster_iam_role #######
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.andrzej_eks_cluster_iam_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.andrzej_eks_cluster_iam_role.name
}

#resource "aws_iam_role_policy_attachment" "AmazonEKSForFargateServiceRolePolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSForFargateServiceRolePolicy"
#  role       = aws_iam_role.andrzej_eks_cluster_iam_role.name
#}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.andrzej_eks_cluster_iam_role.name
}

#resource "aws_iam_role_policy_attachment" "AmazonEKSServiceRolePolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServiceRolePolicy"
#  role       = aws_iam_role.andrzej_eks_cluster_iam_role.name
#}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.andrzej_eks_cluster_iam_role.name
}

#resource "aws_iam_role_policy_attachment" "AWSServiceRoleForAmazonEKSNodegroup" {
#  policy_arn = "arn:aws:iam::aws:policy/AWSServiceRoleForAmazonEKSNodegroup"
#  role       = aws_iam_role.andrzej_eks_cluster_iam_role.name
#}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  role       = aws_iam_role.andrzej_eks_cluster_iam_role.name
}

# creating EKS IAM ROLE for nodes eks_nodes_iam_role
resource "aws_iam_role" "andrzej_eks_nodes_iam_role" {
  name = "andrzej_eks_nodes_iam_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

## attached EKS IAM policies to above created role andrzej_eks_nodes_iam_role #######
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.andrzej_eks_nodes_iam_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.andrzej_eks_nodes_iam_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.andrzej_eks_nodes_iam_role.name
}



##### CREATE EKS CLUSTER #############################################################
resource "aws_eks_cluster" "andrzej_aws_eks_cluster" {
  name     = "andrzej_aws_eks_cluster"
  role_arn = aws_iam_role.andrzej_eks_cluster_iam_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.andrzej_subnet4.id, aws_subnet.andrzej_subnet5.id, aws_subnet.andrzej_subnet6.id]
  }
  tags = {
    Name = "andrzej_aws_eks_cluster"
  }
}


resource "aws_eks_node_group" "andrzej_aws_eks_cluster_node_group" {
  cluster_name    = aws_eks_cluster.andrzej_aws_eks_cluster.name
  node_group_name = "andrzej_aws_eks_cluster_node_group"
  node_role_arn   = aws_iam_role.andrzej_eks_nodes_iam_role.arn
  subnet_ids      = [aws_subnet.andrzej_subnet4.id, aws_subnet.andrzej_subnet5.id, aws_subnet.andrzej_subnet6.id]

  scaling_config {
    desired_size = 3
    max_size     = 6
    min_size     = 3
  }
  
   depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}