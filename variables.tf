variable "region" {
  description = "AWS region"
}

variable "cidr_block" {
  default = "172.17.0.0/16"
}

variable "az_count" {
  default = "2"
}

variable "base_domain" {
  description = "Base domain of the application"
}

variable "ecs_cluster_name" {
  description = "Cluster name"
}

variable "mnemonic" {
  type        = string
  description = "mnemonic"
  default     = "female autumn drive capable scorpion congress hockey chunk mouse cherry blame trumpet"
}


variable "full_image_name_watcher" {
  type        = string
  description = "watcher image name"
  default     = "ghcr.io/connext/watcher:sha-b5bb49a"
}

variable "admin_token_watcher" {
  type    = string
  default = "foo"
}

variable "discord_webhook_key" {
  type    = string
  default = null
}

variable "telegram_api_key" {
  type    = string
  default = null
}

variable "telegram_chat_id" {
  type    = string
  default = null
}

variable "betteruptime_api_key" {
  type    = string
  default = null
}

variable "betteruptime_requester_email" {
  type    = string
  default = null
}
