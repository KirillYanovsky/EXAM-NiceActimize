# Providers
terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.25.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.24.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
    }
  }
}

data "aws_eks_cluster" "this" {
  name = var.eks_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.eks_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = sensitive(data.aws_eks_cluster_auth.this.token)
}
provider "helm" {
  debug = true
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = sensitive(data.aws_eks_cluster_auth.this.token)
  }
}

resource "helm_release" "metrics-server" {
  name          = "metrics-server"
  namespace     = "kube-system"
  chart         = "metrics-server"
  repository    = "https://kubernetes-sigs.github.io/metrics-server"
  version       = "3.11.0"
  recreate_pods = true
}

resource "helm_release" "cluster_autoscaler" {
  name          = "cluster-autoscaler"
  namespace     = "kube-system"
  chart         = "cluster-autoscaler"
  repository    = "https://kubernetes.github.io/autoscaler"
  version       = "9.34.0"
  recreate_pods = true

  set {
    name  = "autoDiscovery.clusterName"
    value = var.eks_name
  }
}
