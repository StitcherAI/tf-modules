terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.30"
    }
  }
}

# Each provider reads its host, IDs, and credentials from a Databricks CLI
# profile in ~/.databrickscfg so no secret is passed through Terraform.
provider "databricks" {
  alias   = "workspace"
  profile = var.workspace_profile
}

provider "databricks" {
  alias   = "account"
  profile = var.account_profile
}

variable "workspace_profile" {
  type        = string
  description = "Databricks CLI profile for the target workspace, created with `databricks auth login --host <WORKSPACE-URL> --profile <NAME>`."
  default     = "stitcherai-workspace"
}

variable "account_profile" {
  type        = string
  description = "Databricks CLI profile for the account console, created with `databricks auth login --host <ACCOUNT-CONSOLE-URL> --account-id <ACCOUNT-ID> --profile <NAME>`."
  default     = "stitcherai-account"
}

variable "catalog_name" {
  type        = string
  description = "Existing Unity Catalog catalog in which this module creates the stitcherai_focus_billing schema and views (e.g. \"main\", or the workspace catalog on serverless workspaces). Must NOT be the read-only `system` catalog."

  validation {
    condition     = lower(var.catalog_name) != "system"
    error_message = "The Databricks `system` catalog is read-only; choose a catalog you own (e.g. \"main\" or your workspace catalog)."
  }
}

variable "account_prices_table_path" {
  type        = string
  description = "Full path to your account prices table. Defaults to system table standard."
  default     = "system.billing.list_prices"
}

variable "sql_warehouse_size" {
  type        = string
  description = "Compute sizing allocation for the StitcherAI compute cluster."
  default     = "2X-Small"
}
