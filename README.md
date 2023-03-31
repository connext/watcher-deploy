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

## Requirements

### 1. Terraform

For ease of dealing with terraform, install [`tfenv`](https://github.com/tfutils/tfenv) and install `terraform`:

```
>>> tfenv install 1.4.4
>>> tfenv use 1.4.4
```

### 2. S3 State bucket

Create an s3 bucket in any region using the default configuration. This bucket will store terraform's state,
so it is really important that it is never deleted or modified manually.

Suggested names: `watcher-deploy-terraform-state`

In `main.tf`, replace the values in:

```
terraform {
  backend "s3" {
    bucket = "watcher-deploy-terraform-state" # Use the name used above
    key    = "state"                          # Can stay the same
    region = "eu-central-1"                   # use the region specified
  }
  required_version = "~> 1.4.4"
}
```

### 3. Variables Required

These need to be set in GHA secrets (or deployment secrets). They will be accessed on CI runtime here: [ci.yaml#L11]()

**3.1. Route53 Zone ID** (`route53_zone_id`) \[REQUIRED\]

For the domain you wish to use, grab the Zone ID from Route 53's console. It looks something like "Z03634792TWUEHHQ5L0YX"

**3.2. Base Domain** (`base_domain`) \[REQUIRED\]

The base domain, of your hosted zone e.g. `connext.ninja`

**3.3. Mnemonic** (`mnemonic`) \[REQUIRED\]

The mnemonic key used by the watcher

**3.4. Watcher docker image** (`full_image_name_watcher`) \[REQUIRED\]

Fetch it from the desired release on Connext's [Github Packages](https://github.com/connext/monorepo/pkgs/container/watcher), e.g. `ghcr.io/connext/watcher:sha-b5bb49a`

**3.4. Watcher's admin token** (`admin_token_watcher`) \[OPTIONAL\]

Randomly generated string for server auth

**3.5. Alerting Secrets** \[OPTIONAL\]

- `discord_webhook_key`
- `telegram_api_key` and `telegram_chat_id`
- `betteruptime_api_key` and `betteruptime_requester_email`

## Deployment & Usage

Deployment should occur only via CICD with Github Actions. However, it is also possible to deploy the infra
from a local set up. Ensure you have the right AWS credentials and `terraform 1.4.4` installed as described above

From top level:

```shell
>>> terraform init
```

Make your changes,

```shell
>>> terraform plan
```

To set custom variables, you can set them with `export TF_ENV_<variable_name>=<variable value>` or use the `tfvars.json` file.
