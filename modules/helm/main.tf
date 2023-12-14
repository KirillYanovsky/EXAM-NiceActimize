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
      version = "2.23.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
  }
}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  debug = true

  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
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
    value = var.cluster_name
  }

  # set {
  #   name = "rbac.serviceAccount.annotations."eks.amazonaws.com/role-arn"
  #   value = "arn:aws:iam::123456789012:role/MyRoleName"
  #   }

}

# resource "helm_release" "app" {
#   name      = var.app_name
#   namespace = kubernetes_namespace.app.metadata[0].name
#   chart     = abspath("${path.module}/../../../../../../../helm")
#   values = [
#     templatefile("${path.module}/templates/app.tpl", {
#       app_environment = var.app_environment
#       app_name        = var.app_name
#       host_name       = "${var.app_name}.${var.hosted_zone_name}"
#     })
#   ]
#   depends_on = [kubernetes_namespace.app]
# }
