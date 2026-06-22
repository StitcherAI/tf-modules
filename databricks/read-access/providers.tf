terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.30"
    }
  }
}

# -----------------------------------------------------------------------------
# Provider authentication
#
# Terraform authenticates as an admin identity (the deployer) using OAuth.
# Two aliases are used, matching the other StitcherAI Databricks modules:
#   - databricks.workspace : workspace-scoped resources (service principal,
#     warehouse, schema, views, grants)
#   - databricks.account   : account-scoped resources (service principal secret)
# -----------------------------------------------------------------------------
provider "databricks" {
  alias         = "workspace"
  host          = var.workspace_host
  client_id     = var.client_id
  client_secret = var.client_secret
}

provider "databricks" {
  alias         = "account"
  host          = var.account_host
  account_id    = var.account_id
  client_id     = var.client_id
  client_secret = var.client_secret
}

variable "workspace_host" {
  type        = string
  description = "Databricks workspace URL (e.g., https://dbc-xxxx.cloud.databricks.com)."
}

variable "account_host" {
  type        = string
  description = "Databricks account-level host (e.g., https://accounts.cloud.databricks.com)."
  default     = "https://accounts.cloud.databricks.com"
}

variable "account_id" {
  type        = string
  description = "Databricks account ID (from the Admin Console)."
}

variable "client_id" {
  type        = string
  description = "OAuth client ID of the admin identity Terraform authenticates as."
}

variable "client_secret" {
  type        = string
  description = "OAuth client secret of the admin identity Terraform authenticates as."
  sensitive   = true
}

variable "catalog_name" {
  type        = string
  description = "The target catalog where the StitcherAI billing schema will reside."
  default     = "main"
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
