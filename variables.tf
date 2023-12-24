variable "region" {
  description = "AWS Region to deploy resources"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Name of project"
  type        = string
  default     = "exam-niceactimize"
}
variable "vpc_name" {
  description = "Name of the VPS"
  type        = string
  default     = "niceactimize-vpc"
}

variable "eks_name" {
  description = "Name of EKS"
  type        = string
  default     = "actimize_eks"
}

variable "eks_workers" {
  description = "List of managed node groups to create for the EKS"
  type = map(object({
    instance_types  = list(string)
    min_size        = number
    max_size        = number
    desired_size    = number
    max_unavailable = list(string)
    }
  ))
  default = {
    default_group = {
      instance_types  = ["t3.medium", "t3.small"]
      min_size        = 1
      max_size        = 5
      desired_size    = 1
      max_unavailable = ["1"]
    }
  }
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_subnets_map" {
  description = "List of subnets"
  type = object({
    public = map(map(object({ cidr = string })))
  })
  default = {
    public = {
      eks1 = {
        eks-public-1a = {
          cidr = "10.0.2.0/24"
        }
      },
      eks2 = {
        eks-public-1b = {
          cidr = "10.0.4.0/24"
        }
      },
      # Add more subnets as needed
    }
  }
}
