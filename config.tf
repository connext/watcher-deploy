locals {
  watcher_env_vars = [
    { name = "WATCHER_CONFIG", value = local.local_watcher_config },
    { name = "WATCHER_MNEMONIC", value = var.mnemonic },
    { name = "WATCHER_ADMIN_TOKEN", value = var.admin_token_watcher },
    { name = "DISCORD_HOOK_URL", value = var.discord_webhook_key != null ? "https://discord.com/api/webhooks/${var.discord_webhook_key}" : null },
    { name = "TELEGRAM_API_KEY", value = var.telegram_api_key != null ? var.telegram_api_key : null },
    { name = "TELEGRAM_CHAT_ID", value = var.telegram_chat_id != null ? var.telegram_chat_id : null },
    { name = "BETTER_UPTIME_API_KEY", value = var.betteruptime_api_key != null ? var.betteruptime_api_key : null },
    { name = "BETTER_UPTIME_REQUESTER_EMAIL", value = var.betteruptime_requester_email != null ? var.betteruptime_requester_email : null },

  ]
}

locals {
  local_watcher_config = jsonencode({
    server = {
      adminToken = var.admin_token_watcher
      port       = 8080

    }
    environment = "production"
    logLevel    = "debug"
    chains = {
      "6648936" = {
        providers = ["https://eth.llamarpc.com", "https://rpc.ankr.com/eth", "https://api.zmok.io/mainnet/oaen6dy8ff6hju9k"]
      },
      "1869640809" = {
        providers = ["https://mainnet.optimism.io", "https://rpc.ankr.com/optimism"]
      },
      "1886350457" = {
        providers = ["https://polygon.llamarpc.com", "https://polygon-bor.publicnode.com", "https://rpc.ankr.com/polygon"]
      }
      "1634886255" = {
        providers = ["https://arb1.arbitrum.io/rpc", "https://rpc.ankr.com/arbitrum"]
      }
      "6450786" = {
        providers = ["https://bsc-dataseed1.binance.org", "https://bsc-dataseed2.binance.org", "https://rpc.ankr.com/bsc", "https://bsc-dataseed1.defibit.io"]
      }
      "6778479" = {
        providers = ["https://rpc.gnosischain.com", "https://rpc.ankr.com/gnosis", "https://xdai-rpc.gateway.pokt.network", "https://rpc.gnosis.gateway.fm"]
      }
    }
    hubDomain = "6648936"
  })
}
