locals {
  tags = {
    Project   = var.project_name
    Terraform = "true"
    Owner     = "KirillYanovsky"
  }
}

# Create VPC
module "vpc" {
  source = "./modules/vpc"

  vpc_name        = var.vpc_name
  eks_name        = lower(var.eks_name)
  cidr_block      = var.cidr_block
  vpc_subnets_map = var.vpc_subnets_map

  tags = local.tags
}

# Create EKS Cluster
module "eks" {
  source = "./modules/eks"

  eks_name    = var.eks_name
  subnet_ids  = module.vpc.public_subnet_ids
  eks_workers = var.eks_workers

  tags = local.tags
}

module "helm" {
  source = "./modules/helm"

  eks_name = var.eks_name

  #depends_on = [module.eks]
}
