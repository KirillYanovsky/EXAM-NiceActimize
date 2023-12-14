locals {
  name = "Exam-Actimize"
  tags = {
    Name      = local.name
    Terraform = "true"
    Owner     = "KirillYanovsky"
  }
}

# Create VPC
module "vpc" {
  source = "./modules/vpc"

  vpc_name = var.vpc_name
  eks_name = lower(var.eks_name)
  tags     = local.tags
}

# Create EKS Cluster
module "eks" {
  source = "./modules/eks"

  eks_name   = var.eks_name
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  tags       = local.tags
}

module "helm" {
  source = "./modules/helm"

  cluster_name = var.eks_name
}
