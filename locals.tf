locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }

  tags = merge(local.default_tags, var.extra_tags)
}
