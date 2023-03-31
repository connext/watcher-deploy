terraform {
  backend "s3" {
    bucket = "test-tf-state-watcher"
    key    = "state"
    region = "eu-central-1"
  }
  required_version = "~> 1.4.4"
}

provider "aws" {
  region = var.region
}

# Fetch AZs in the current region
data "aws_availability_zones" "available" {}

data "aws_iam_role" "ecr_admin_role" {
  name = "erc_admin_role"
}

data "aws_caller_identity" "current" {}


module "watcher" {
  source                   = "./config/modules/service"
  region                   = var.region
  execution_role_arn       = data.aws_iam_role.ecr_admin_role.arn
  cluster_id               = module.ecs.ecs_cluster_id
  vpc_id                   = module.network.vpc_id
  private_subnets          = module.network.private_subnets
  lb_subnets               = module.network.public_subnets
  docker_image             = var.full_image_name_watcher
  container_family         = "watcher"
  health_check_path        = "/ping"
  container_port           = 8080
  loadbalancer_port        = 80
  cpu                      = 1024
  memory                   = 2048
  instance_count           = 1
  timeout                  = 180
  ingress_cdir_blocks      = [module.network.vpc_cdir_block]
  ingress_ipv6_cdir_blocks = []
  service_security_groups  = flatten([module.network.allow_all_sg, module.network.ecs_task_sg])
  container_env_vars       = local.watcher_env_vars
  base_domain              = var.base_domain
}


module "network" {
  source     = "./config/modules/networking"
  cidr_block = var.cidr_block
}


module "ecs" {
  source           = "./config/modules/ecs"
  ecs_cluster_name = var.ecs_cluster_name
}


module "iam" {
  source = "./config/modules/iam"
}
