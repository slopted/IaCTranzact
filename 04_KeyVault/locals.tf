locals {
    rg_name = "${var.name_prefix}-rg"
    nsg1_name = "${var.name_prefix}-nsg1"
    nsg2_name = "${var.name_prefix}-nsg2"
    vnet_name = "${var.name_prefix}-vnet"
    keyv_name = "${var.name_prefix}-keyv"
    keyv_secret_name = "${var.name_prefix}-IaCSPN-secret"
    tags = {
    owner = "Andres Sanchez"
    environment = "prod"
    source = "terraform"
    }
    user_object = "f47e4f83-9da5-4714-9df3-3977899eca8e"
}
