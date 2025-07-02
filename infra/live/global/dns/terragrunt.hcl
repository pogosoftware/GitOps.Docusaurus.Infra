include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "../../..//components/dns"
}

inputs = {
  resource_group_name = include.root.locals.resource_group_name
}
