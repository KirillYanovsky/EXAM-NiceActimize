terraform {
  source = "${include.root.locals.resource_vars["tf_source"]}"
}

include "root" {
  path   = "${find_in_parent_folders()}"
  expose = true
}

inputs = include.root.locals.resource_vars["inputs"]
