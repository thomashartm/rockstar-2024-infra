include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "component" {
  path   = "${dirname(find_in_parent_folders())}/_common/vpc.hcl"
  expose = true
}

inputs = {
}