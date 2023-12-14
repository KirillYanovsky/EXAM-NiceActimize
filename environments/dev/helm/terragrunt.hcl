terraform {
  source = include.root.locals.resource_vars["tf_source"]
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

inputs = merge(
  include.root.locals.resource_vars["inputs"],
  {
    cluster_name    = dependency.eks.outputs.cluster_name
    certificate_arn = dependency.acm.outputs.certificate_arn
  }
)

dependencies {
  paths = [
    "../eks",
    "../acm"
  ]
}

dependency "eks" {
  config_path = "../eks"
  mock_outputs = {
    cluster_name = "test-cluster"
  }
}

dependency "acm" {
  config_path = "../acm"
  mock_outputs = {
    certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
  }
}
