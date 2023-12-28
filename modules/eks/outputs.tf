output "eks_name" {
  description = "EKS Cluster Name"
  value       = aws_eks_cluster.this.name
}

data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.this.name
}

output "hostname" {
  description = "Hostname of the EKS cluster"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_ca_certificate" {
  description = "Nested attribute containing certificate-authority-data for your cluster."
  value       = aws_eks_cluster.this.certificate_authority
}

output "token" {
  description = "The token to use to authenticate with the cluster."
  value       = data.aws_eks_cluster_auth.this.token
  sensitive   = true
}
