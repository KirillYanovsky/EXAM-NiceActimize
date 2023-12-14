terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = var.eks_name
  cluster_version = var.cluster_version

  vpc_id                          = var.vpc_id
  subnet_ids                      = var.subnet_ids
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    one = {
      name = "ng-1"

      instance_types = ["t3.small", "t3.medium"]

      min_size     = 1
      max_size     = 5
      desired_size = 1
    }
  }

  tags = merge(
    var.tags,
    {
      Name = var.eks_name
    }
  )
}

resource "aws_eks_addon" "addons" {
  for_each     = var.cluster_addons
  cluster_name = module.eks.cluster_name
  addon_name   = each.key

  tags = {
    "eks_addon" = each.key
    "terraform" = "true"
  }
}
