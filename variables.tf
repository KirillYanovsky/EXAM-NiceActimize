variable "region" {
  description = "AWS Region to deploy resources"
  type        = string
  default     = "eu-central-1"
}

variable "vpc_name" {
  description = "Name of the VPS"
  type        = string
  default     = "niceactimize-vpc"
}

variable "eks_name" {
  description = "Mane of EKS"
  type        = string
  default     = "actimize_eks"
}
