variable "ecs_cluster_name_prefix" {
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "vpc_id" {}
