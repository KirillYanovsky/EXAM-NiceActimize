variable "eks_name" {
  description = "Name of EKS"
  type        = string
  default     = "actimize_eks"
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.28"
}

variable "vpc_id" {
  description = "ID of the VPC to deploy the EKS cluster into"
  type        = string
}

variable "subnet_ids" {
  description = "IDs of the subnets to deploy the EKS cluster into"
  type        = list(string)
}

variable "cluster_addons" {
  description = "List of addons to enable for the EKS cluster"
  type        = map(map(bool))
  default = {
    coredns = {
      most_recent : true
    },
    vpc-cni = {
      most_recent : true
    },
    aws-ebs-csi-driver = {
      most_recent : true
    }
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
