variable "vpc_name" {
  description = "Name of the VPS"
  type        = string
  default     = "actimize-vpc"
}

variable "eks_name" {
  description = "Name of EKS"
  type        = string
  default     = "actimize_eks"
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  #default     = "10.0.0.0/16"
}

variable "vpc_subnets_map" {
  description = "List of subnets"
  type = object({
    public = map(map(object({ cidr = string })))
  })
  default = {
    public = {}
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
