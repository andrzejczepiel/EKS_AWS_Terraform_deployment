
##############################################################################
##### OUTPUT SECTION #########################################################

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.andrzej_aws_eks_cluster.endpoint
}

output "eks_cluster_certificat_authority" {
  value = aws_eks_cluster.andrzej_aws_eks_cluster.certificate_authority 
}