variable "region" {
  default = "us-east-2"
}

variable "cidr_block" {
  default = "172.17.0.0/16"
}

variable "az_count" {
  default = "2"
}

variable "ecs_cluster_name" {
  description = "Cluster name"
}

variable "route53_zone_id" {
  type = string
}

variable "mnemonic" {
  type        = string
  description = "mnemonic"
  default     = "female autumn drive capable scorpion congress hockey chunk mouse cherry blame trumpet"
}

variable "certificate_arn" {
  default = "arn:aws:acm:us-east-2:679752396206:certificate/eecbb4dd-f537-40f0-afdb-233ee066ba80"
}

variable "mainnet_alchemy_key_0" {
  type = string
}

variable "mainnet_alchemy_key_1" {
  type = string
}

variable "optimism_alchemy_key_0" {
  type = string
}

variable "optimism_alchemy_key_1" {
  type = string
}

variable "polygon_alchemy_key_0" {
  type = string
}

variable "polygon_alchemy_key_1" {
  type = string
}

variable "arbitrum_alchemy_key_0" {
  type = string
}

variable "arbitrum_alchemy_key_1" {
  type = string
}

variable "blast_key" {
  type = string
}


variable "gelato_api_key" {
  type = string
}

variable "connext_relayer_api_key" {
  type    = string
  default = "foo"
}


variable "full_image_name_watcher" {
  type        = string
  description = "watcher image name"
  default     = "ghcr.io/connext/watcher:sha-b5bb49a"
}

variable "admin_token_relayer" {
  type    = string
  default = "blahblah"
}

variable "graph_api_key" {
  type = string
}

variable "admin_token_watcher" {
  type    = string
  default = "blahblah"
}

variable "discord_webhook_key" {
  type = string
}

variable "telegram_api_key" {
  type = string
}

variable "telegram_chat_id" {
  type = string
}

variable "betteruptime_api_key" {
  type = string
}

variable "betteruptime_requester_email" {
  type    = string
  default = "layne@connext.network"
}
