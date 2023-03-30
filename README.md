## AWS Infrastructure

This folder contains all the code necessary to deploy the watcher service to a brand new ECS cluster

- Fully configured load balancing, port forwarding, and TLS
- Autoscaling with ECS on [Fargate](https://aws.amazon.com/fargate/)
- Reusable Infrastructure as Code, modularized as Terraform components

## Scaffolding

```text
config
 ├── main.tf         <- Entrypoint for all the module instantiations
 ├── variables.tf    <- Required input variables
 ├── outputs.tf      <- Generated console outputs
 ├── config.tf       <- Configuration for service
 └── modules
      ├── service    <- Generic, configurable ECS service
      ├── ecs        <- ECS cluster definition
      ├── iam        <- IAM roles needed for ECS
      ├── kms        <- KMS and secrets
      ├── kms        <- KMS and secrets
      └── networking <- VPCs, Subnets and all those shenanigans

```

## Deployment & Usage

Deployment should occur only via CICD with Github Actions. However, it is also possible to deploy the infra
from a local set up. Ensure you have the right AWS credentials and `terraform 1.1.7` installed
([instructions](https://learn.hashicorp.com/tutorials/terraform/install-cli))

Then, navigate to the `environment` you'd like to operate on (`testnet`, `staging`, `mainnet`), and do:

```shell
>>> terraform init
```

Make your changes,

```shell
>>> terraform plan
```

To set custom variables, you can set them with `export TF_ENV_<variable_name>=<variable value>`
