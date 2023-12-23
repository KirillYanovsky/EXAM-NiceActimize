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
  description = "Tags to apply to the EKS"
  type        = map(string)
  default     = {}
}
