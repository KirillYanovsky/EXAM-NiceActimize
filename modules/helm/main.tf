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
}
