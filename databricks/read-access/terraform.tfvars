# Target configuration settings for StitcherAI
sql_warehouse_size = "Small"

# Databricks CLI profiles Terraform authenticates with. Create them before
# running terraform:
#   databricks auth login --host https://dbc-xxxx.cloud.databricks.com --profile stitcherai-workspace
#   databricks auth login --host https://accounts.cloud.databricks.com --account-id <ACCOUNT-ID> --profile stitcherai-account
workspace_profile = "stitcherai-workspace"
account_profile   = "stitcherai-account"
