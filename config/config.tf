locals {
  watcher_env_vars = [
    { name = "WATCHER_CONFIG", value = local.local_watcher_config },
    { name = "ENVIRONMENT", value = var.environment },
    { name = "STAGE", value = var.stage },
    { name = "DD_PROFILING_ENABLED", value = "true" },
    { name = "DD_ENV", value = var.stage }
  ]
  watcher_web3signer_env_vars = [
    { name = "WEB3_SIGNER_PRIVATE_KEY", value = var.watcher_web3_signer_private_key },
    { name = "WEB3SIGNER_HTTP_HOST_ALLOWLIST", value = "*" },
    { name = "ENVIRONMENT", value = var.environment },
    { name = "STAGE", value = var.stage },
    { name = "DD_ENV", value = "${var.environment}-${var.stage}" },
  ]
}

locals {
  local_watcher_config = jsonencode({
    server = {
      adminToken = var.admin_token_watcher
    }
    environment = "production"
    logLevel    = "debug"
    chains = {
      "6648936" = {
        providers = ["https://eth-mainnet.blastapi.io/${var.blast_key}", "https://eth.llamarpc.com", "https://rpc.ankr.com/eth", "https://api.zmok.io/mainnet/oaen6dy8ff6hju9k"]
      },
      "1869640809" = {
        providers = ["https://optimism-mainnet.blastapi.io/${var.blast_key}", "https://mainnet.optimism.io", "https://rpc.ankr.com/optimism"]
      },
      "1886350457" = {
        providers = ["https://polygon-mainnet.blastapi.io/${var.blast_key}", "https://polygon.llamarpc.com", "https://polygon-bor.publicnode.com", "https://rpc.ankr.com/polygon"]
      }
      "1634886255" = {
        providers = ["https://arb-mainnet.g.alchemy.com/v2/${var.arbitrum_alchemy_key_0}", "https://arb1.arbitrum.io/rpc", "https://rpc.ankr.com/arbitrum"]
      }
      "6450786" = {
        providers = ["https://bsc-mainnet.blastapi.io/${var.blast_key}", "https://bsc-dataseed1.binance.org", "https://bsc-dataseed2.binance.org", "https://rpc.ankr.com/bsc", "https://bsc-dataseed1.defibit.io"]
      }
      "6778479" = {
        providers = ["https://gnosis-mainnet.blastapi.io/${var.blast_key}", "https://rpc.gnosischain.com", "https://rpc.ankr.com/gnosis", "https://xdai-rpc.gateway.pokt.network", "https://rpc.gnosis.gateway.fm"]
      }
    }
    mnemonic                   = var.mnemonic
    environment                = var.stage
    discordHookUrl             = "https://discord.com/api/webhooks/${var.discord_webhook_key}"
    telegramApiKey             = "${var.telegram_api_key}"
    telegramChatId             = "${var.telegram_chat_id}"
    betterUptimeApiKey         = "${var.betteruptime_api_key}"
    betterUptimeRequesterEmail = "${var.betteruptime_requester_email}"
  })
}
