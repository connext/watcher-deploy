variable "account_id" {
  type = string
}

locals {
  service_user = [
    "arn:aws:iam::${account_id}:user/watcher",
  ]
}


locals {
  key_admin = [
    "arn:aws:iam::${account_id}:user/aws-deployer",
  ]
}


locals {
  users = {
    key_admin = {
      name = "key_admin_user"
      tags = {
        environment = "all"
      }
      policy = file("${path.module}/policies/key-admin-policy.json")
    }
  }
}

locals {
  keys = {
    staging = {
      description             = "Key for staging env using SOPS"
      deletion_window_in_days = 7
      policy = templatefile("${path.module}/policies/key-policy.tpl", {
        key_users = local.service_user,
        key_admin = local.key_admin
      })
      enable_key_rotation = true
    }
  }
}


