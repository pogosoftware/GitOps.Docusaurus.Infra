include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

include "env" {
  path = find_in_parent_folders("env.hcl")
  expose = true
}

terraform {
  source = "../../..//components/acr"
}

inputs = {
  resource_group_name = include.root.locals.resource_group_name
  acr_name            = include.env.locals.acr_name
}
