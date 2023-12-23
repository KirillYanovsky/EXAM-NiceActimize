terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.25.0"
    }
  }
}

data "aws_region" "current" {}

locals {
  has_public_subnets   = var.vpc_subnets_map["public"] != null
  public_subnets_cidrs = local.has_public_subnets ? flatten([for subnet in var.vpc_subnets_map["public"] : [for v in values(subnet) : v.cidr]]) : []
  public_subnets_names = local.has_public_subnets ? flatten([for subnet in var.vpc_subnets_map["public"] : keys(subnet)]) : []
  public_subnets_map   = zipmap(local.public_subnets_names, local.public_subnets_cidrs)
}

locals {
  public_subnet_ids = [for subnet in aws_subnet.public : subnet.id]
}

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.tags,
    {
      Name = var.vpc_name
    }
  )
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = var.tags
}

resource "aws_subnet" "public" {
  for_each                = local.public_subnets_map
  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = "${data.aws_region.current.name}${lower(substr(each.key, -1, 1))}"
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name                                    = each.key
      AvailabilityZone                        = "${data.aws_region.current.name}${lower(substr(each.key, -1, 1))}"
      SubnetType                              = "Public"
      "kubernetes.io/cluster/${var.eks_name}" = "shared"
      "kubernetes.io/role/elb"                = 1
    }
  )
}

resource "aws_route_table" "public" {
  count  = length(local.public_subnet_ids)
  vpc_id = aws_vpc.this.id

  tags = var.tags
}
resource "aws_route" "public" {
  count                  = length(aws_route_table.public)
  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
  depends_on             = [aws_route_table.public]
}

resource "aws_route_table_association" "public" {
  count          = length(local.public_subnet_ids)
  subnet_id      = local.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public[count.index].id
  depends_on     = [aws_route_table.public]
}
