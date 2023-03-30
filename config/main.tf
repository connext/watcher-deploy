terraform {
  backend "s3" {
    bucket = "nxtp-terraform-mainnet-prod-core"
    key    = "state/"
    region = "us-east-1"
  }
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

data "aws_route53_zone" "primary" {
  zone_id = var.route53_zone_id
}


module "watcher" {
  source                   = "./modules/service"
  region                   = var.region
  zone_id                  = data.aws_route53_zone.primary.zone_id
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
  cert_arn                 = var.certificate_arn
  container_env_vars       = local.watcher_env_vars
}


module "network" {
  source     = "./modules/networking"
  cidr_block = var.cidr_block
}


module "ecs" {
  source           = "./modules/ecs"
  ecs_cluster_name = var.ecs_cluster_name
}


module "iam" {
  source = "./modules/iam"
}

module "kms" {
  source     = "./modules/kms"
  account_id = data.aws_caller_identity.current.account_id
}
