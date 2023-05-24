variable "client_secret" {
}

terraform {
  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "IaCTranzact-rg"
    storage_account_name = "iactranzactsaprod"
    container_name       = "iactranzact-sa-con"
    key                  = "terraform.tfstate"
    access_key           = "7/+tUVQ229Wto6NMwwU3get6NZi8U0zZzU1V7J12lD3jwTwGL2z5+R6TfC+UXpWIHIYq6NyEqnhD+AStASkFNw=="
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
    
    client_id       = "efb217ae-b957-4974-98d8-d709afb97910"
    client_secret   = var.client_secret
    tenant_id       = "4f6d7b32-765b-4ee0-9220-c1b15c5d1cd1"
    subscription_id = "b6a62966-b130-4dac-8f3c-4d383743f382"

}
