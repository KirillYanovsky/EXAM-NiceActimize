terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.25.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.24.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~>2.12.1"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "2.4.0"
    }
  }
  # backend "s3" {
  #   bucket         = "300732800381-tfstate"
  #   key            = "aws-lab.tfstate"
  #   region         = "eu-central-1"
  #   dynamodb_table = "aws-lab-terraform-state-locking"
  # }
}

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = module.eks.hostname
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate[0].data)
  token                  = sensitive(module.eks.token)
}

provider "helm" {
  debug = true
  kubernetes {
    host                   = module.eks.hostname
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate[0].data)
    token                  = sensitive(module.eks.token)
  }
}
