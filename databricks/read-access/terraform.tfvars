# Target configuration settings for StitcherAI
catalog_name       = "main"
sql_warehouse_size = "Small"

# Default fallback is system table standard.
# For Account Prices Preview (AWS/GCP), update this path string to "system.billing.account_prices"
account_prices_table_path = "system.billing.list_prices"

# Provider authentication — fill these in before running terraform.
# workspace_host = "https://dbc-xxxx.cloud.databricks.com"
# account_host   = "https://accounts.cloud.databricks.com"
# account_id     = ""
# client_id      = ""
# client_secret  = ""
