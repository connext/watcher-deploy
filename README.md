## AWS Infrastructure

This folder contains all the code necessary to deploy the watcher service to a brand new ECS cluster

- Fully configured load balancing, port forwarding, and TLS
- Autoscaling with ECS on [Fargate](https://aws.amazon.com/fargate/)
- Reusable Infrastructure as Code, modularized as Terraform components

## Scaffolding

```text
.github/workflows/ci.yaml    <- CI Workflow
config
 ├── main.tf                 <- Entrypoint for all the module instantiations
 ├── variables.tf            <- Required input variables
 ├── outputs.tf              <- Generated console outputs
 ├── config.tf               <- Configuration for service
 └── modules
      ├── service            <- Generic, configurable ECS service
      ├── ecs                <- ECS cluster definition
      ├── iam                <- IAM roles needed for ECS
      └── networking         <- VPCs, Subnets and all those shenanigans

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

## 3. Variables

### 3.1 Non-secret Variables

These should be placed in the `tfvars.json` file. They include

**3.1.1. Base Domain** (`base_domain`) \[REQUIRED\]

The base domain, of your hosted zone e.g. `connext.ninja`

**3.1.2. Watcher docker image** (`full_image_name_watcher`) \[REQUIRED\]

Fetch it from the desired release on Connext's [Github Packages](https://github.com/connext/monorepo/pkgs/container/watcher), e.g. `ghcr.io/connext/watcher:sha-b5bb49a`

**3.1.3. ECS Cluster Name** (`ecs_cluster_name`) \[REQUIRED\]

Name of the cluster. Must not contain spaces. E.g. `watcher-deploy`

**3.1.4. AWS Region** (`region`) \[REQUIRED\]

Region to which the cluster will be deployed

### 3.2 Secret Variables

These need to be set in GHA secrets (or deployment secrets). They will be accessed on CI runtime here: [ci.yaml#L11](https://github.com/connext/watcher-deploy/blob/main/.github/workflows/ci.yaml#L11-L26)

These need to be set exactly as named, e.g.

Make sure to edit the `ci.yaml` accordingly, if you plan on using the optional (commented out) variables.

**3.2.1. Mnemonic** (`MNEMONIC`) \[REQUIRED\]

The mnemonic key used by the watcher

**3.2.2. Watcher's admin token** (`ADMIN_TOKEN_WATCHER`) \[OPTIONAL\]

Randomly generated string for server auth

**3.2.3. Alerting Secrets** \[OPTIONAL\]

- `DISCORD_WEBHOOK_KEY`
- `TELEGRAM_API_KEY` and `TELEGRAM_CHAT_ID`
- `BETTERUPTIME_API_KEY` and `BETTERUPTIME_REQUESTER_EMAIL`

## Deployment & Usage

Deployment should occur only via CICD with Github Actions. However, it is also possible to deploy the infra
from a local set up. Ensure you have the right AWS credentials and `terraform 1.4.4` installed as described above

Also, you'll need to have set the secrets to your environment:

```shell
export TF_VAR_mnemonic="emale autumn drive capable scorpion congress hockey chunk ..."
export TF_VAR_admin_token_router="foo"
...
```

From top level:

```shell
>>> terraform init
```

Plan the changes:

```shell
>>> terraform plan -var-file=tfvars.json
```

To set custom variables, you can set them with `export TF_ENV_<variable_name>=<variable value>` or use the `tfvars.json` file.

```shell
>>> terraform apply var-file=tfvars.json -auto-approve
```
