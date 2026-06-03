# Snowflake Read Access to Cost or Business Datasets

To enable StitcherAI to build a comprehensive cost model for your organization, access to cost and usage data from Snowflake is required. Additionally, organizations may store business datasets and share those datasets using Snowflake's data-sharing capabilities. In both cases, customers will need to grant access to StitcherAI to read the limited datasets from their Snowflake accounts. This document covers how organizations can securely grant access to StitcherAI for both situations.

## Cost Data Access

To retrieve cost data from Snowflake, StitcherAI needs access to the cost and usage tables in the Snowflake Organization account. The relevant cost and usage datasets are stored in the system tables in Snowflake, specifically under the schema called `ORGANIZATION_USAGE` under the database called `SNOWFLAKE`.

**Note**: Rather than requesting access to the `SNOWFLAKE.ORGANIZATION_USAGE` schema directly, the StitcherAI setup process creates a separate database and schema specifically for StitcherAI. This provides a clear separation of what StitcherAI can access.

### Setup Script

The following SQL script guides you through the process of granting access to the cost and usage related tables so that StitcherAI can build the cost datasets for Snowflake.

**Before running the script, please review and update the variables in Step 1**:

- Find the StitcherAI environment ID you're granting access to (available in the [StitcherAI web app](https://app.stitcher.ai/environments)).

Optionally, update the following items if you want to use values different from the defaults. If you change any of these, record them so you can enter them when creating the data connection in the StitcherAI WebUI:

- Username
- Role name, warehouse name, and warehouse size
- Database and schema names
- GCS integration name

**The script performs the following actions**:

1. Sets up the user, role, database, etc. and creates a PAT (personal access token) for authentication.
2. Sets up the GCS integration.
3. Replicates a limited set of cost and usage views into the StitcherAI-specific database and schema.
4. Grants the user and role created in Step 1 read-only access to those views.

**Important**: Record the following data so the StitcherAI data source can be created in the StitcherAI web UI:

- Step 1 values for required keys:
  - Snowflake username and token (PAT)
- Step 1 values for optional keys (only needed if the default values are not used):
  - Database name (`database_for_reads`)
  - Schema name (`schema_for_reads`)
  - Read role (`stitcherai_reader_role`)
  - Warehouse name (`stitcherai_warehouse`)
  - GCS integration name (`gcs_integration_name`)
- Step 6 output for key `STORAGE_GCP_SERVICE_ACCOUNT`

```sql
-- SQL script for setting up Snowflake cost read access for StitcherAI

----------------------------------------------------------------------------------------------------
-- Step 1: Fill variables
-- Provide all necessary information for the setup (names for users, roles, database/schema, etc.)
-- More information above in the section:
--   "Before running the script, please review and update the variables in Step 1:"
----------------------------------------------------------------------------------------------------

set stitcherai_environment_id='??'; -- Replace with your StitcherAI environment ID (see section above)
set stitcherai_user='stitcherai_reader';
set stitcherai_reader_role='stitcherai_reader';
set stitcherai_warehouse='stitcherai';
set stitcherai_warehouse_size='SMALL';

set gcs_integration_name = 'stitcherai_gcs_int';
set database_for_reads ='stitcherai';
set schema_for_reads = 'source_data';
set fq_schema = concat($database_for_reads, '.', $schema_for_reads);

use role accountadmin;

---------------------------------------------------------------------------------------------------
-- Step 2: Basic setup
-- Create users, token, roles, database/schema, etc.
---------------------------------------------------------------------------------------------------

create warehouse if not exists IDENTIFIER($stitcherai_warehouse)
    AUTO_SUSPEND=60
    INITIALLY_SUSPENDED=TRUE
    WAREHOUSE_SIZE=$stitcherai_warehouse_size;

create role IDENTIFIER($stitcherai_reader_role);

grant all on warehouse IDENTIFIER($stitcherai_warehouse) to role IDENTIFIER($stitcherai_reader_role);

create database if not exists IDENTIFIER($database_for_reads);
create schema if not exists IDENTIFIER($fq_schema);

CREATE USER IDENTIFIER($stitcherai_user)
    DEFAULT_WAREHOUSE=$stitcherai_warehouse
    DEFAULT_ROLE=$stitcherai_reader_role;
  
grant role IDENTIFIER($stitcherai_reader_role) to user IDENTIFIER($stitcherai_user);

-- **** IMPORTANT **** --
-- Update as needed to meet your organization's security policies. The authentication policy below has default values.
-- Use this default network policy if your organization doesn't have a default policy it applies to accounts.
-- If IP restrictions are necessary, please notify your StitcherAI contact so we can provide the subnets StitcherAI
-- will connect from. The user access required here is limited and may not require additional policies for the token.
USE DATABASE IDENTIFIER($database_for_reads);

CREATE AUTHENTICATION POLICY stitcher_authentication_policy
  PAT_POLICY=(
    NETWORK_POLICY_EVALUATION = ENFORCED_NOT_REQUIRED
    MAX_EXPIRY_IN_DAYS=365
    DEFAULT_EXPIRY_IN_DAYS=30
  );

ALTER USER IDENTIFIER($stitcherai_user) SET AUTHENTICATION POLICY stitcher_authentication_policy;

-- **** IMPORTANT **** --
-- SAVE the personal access token (PAT) generated from the command below. This will be needed
-- to set up the Snowflake connection in the StitcherAI WebUI in a subsequent step.
ALTER USER IF EXISTS IDENTIFIER($stitcherai_user) ADD PROGRAMMATIC ACCESS TOKEN stitcher_pat 
  DAYS_TO_EXPIRY = 365;

---------------------------------------------------------------------------------------------------
-- Step 3: Setup GCS integration
-- Setup the Google Cloud Storage integration for StitcherAI to export the dataset
---------------------------------------------------------------------------------------------------

set gcs_path_prod = concat('gcs://stitcher-gcs-processing-bucket-prod-r1-na/processed/environments/Environment=', $stitcherai_environment_id, '/');

create storage integration if not exists IDENTIFIER($gcs_integration_name)
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'GCS'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ($gcs_path_prod)
  -- STORAGE_BLOCKED_LOCATIONS = ()
  ;

---------------------------------------------------------------------------------------------------
-- Step 4: Create views in the source database/schema
--
-- Create a set of views based on existing system views in a StitcherAI-specific database and
-- schema to manage access without exposing non-cost related system tables.
--
-- ******IMPORTANT:******
-- Replace the database (default: stitcherai) and schema name (default: source_data)
-- in the statements below if you specified a different database or schema name in Step 1.
-- The CREATE VIEW DDL does not support variable substitution.
---------------------------------------------------------------------------------------------------
create or replace view stitcherai.source_data.USAGE_IN_CURRENCY_DAILY 
as select ORGANIZATION_NAME, CONTRACT_NUMBER, ACCOUNT_NAME, ACCOUNT_LOCATOR, REGION, 
    SERVICE_LEVEL, USAGE_DATE, USAGE_TYPE, USAGE, CURRENCY, USAGE_IN_CURRENCY, 
    BALANCE_SOURCE, BILLING_TYPE, RATING_TYPE, SERVICE_TYPE, IS_ADJUSTMENT
    from SNOWFLAKE.ORGANIZATION_USAGE.USAGE_IN_CURRENCY_DAILY;
create or replace view stitcherai.source_data.RATE_SHEET_DAILY 
as select DATE, ORGANIZATION_NAME, CONTRACT_NUMBER, ACCOUNT_NAME, ACCOUNT_LOCATOR, 
    REGION, SERVICE_LEVEL, USAGE_TYPE, CURRENCY, EFFECTIVE_RATE, SERVICE_TYPE, 
    RATING_TYPE, BILLING_TYPE, IS_ADJUSTMENT 
    from SNOWFLAKE.ORGANIZATION_USAGE.RATE_SHEET_DAILY;
create or replace view stitcherai.source_data.CONTRACT_ITEMS 
as select ORGANIZATION_NAME, CONTRACT_NUMBER, START_DATE, END_DATE, 
    EXPIRATION_DATE, CONTRACT_ITEM, CURRENCY, AMOUNT, CONTRACT_MODIFIED_DATE 
    from SNOWFLAKE.ORGANIZATION_USAGE.CONTRACT_ITEMS;
create or replace view stitcherai.source_data.REMAINING_BALANCE_DAILY 
as select ORGANIZATION_NAME, CONTRACT_NUMBER, DATE, CURRENCY, FREE_USAGE_BALANCE, 
    CAPACITY_BALANCE, ON_DEMAND_CONSUMPTION_BALANCE, ROLLOVER_BALANCE, 
    MARKETPLACE_CAPACITY_DRAWDOWN_BALANCE
    from SNOWFLAKE.ORGANIZATION_USAGE.REMAINING_BALANCE_DAILY;
create or replace view stitcherai.source_data.WAREHOUSE_METERING_HISTORY 
as select ORGANIZATION_NAME, ACCOUNT_NAME, REGION, SERVICE_TYPE, START_TIME, 
    END_TIME, WAREHOUSE_ID, WAREHOUSE_NAME, CREDITS_USED, CREDITS_USED_COMPUTE, 
    CREDITS_USED_CLOUD_SERVICES, ACCOUNT_LOCATOR 
    from SNOWFLAKE.organization_usage.WAREHOUSE_METERING_HISTORY;
create or replace view stitcherai.source_data.PIPE_USAGE_HISTORY 
as select ORGANIZATION_NAME, ACCOUNT_NAME, ACCOUNT_LOCATOR, REGION, PIPE_ID,
    PIPE_NAME, USAGE_DATE, CREDITS_USED, BYTES_INSERTED, FILES_INSERTED
    from SNOWFLAKE.organization_usage.PIPE_USAGE_HISTORY;
create or replace view stitcherai.source_data.AUTOMATIC_CLUSTERING_HISTORY 
as select ORGANIZATION_NAME, ACCOUNT_NAME, ACCOUNT_LOCATOR, REGION, USAGE_DATE, 
    CREDITS_USED, NUM_BYTES_RECLUSTERED, NUM_ROWS_RECLUSTERED, TABLE_ID, TABLE_NAME, 
    SCHEMA_ID, SCHEMA_NAME, DATABASE_ID, DATABASE_NAME 
    from SNOWFLAKE.organization_usage.AUTOMATIC_CLUSTERING_HISTORY;
create or replace view stitcherai.source_data.MATERIALIZED_VIEW_REFRESH_HISTORY 
as select ORGANIZATION_NAME, ACCOUNT_NAME, ACCOUNT_LOCATOR, REGION, USAGE_DATE, 
    CREDITS_USED, TABLE_ID, TABLE_NAME, SCHEMA_ID, SCHEMA_NAME, DATABASE_ID, 
    DATABASE_NAME
    from SNOWFLAKE.organization_usage.MATERIALIZED_VIEW_REFRESH_HISTORY;
create or replace view stitcherai.source_data.SEARCH_OPTIMIZATION_HISTORY 
as select ORGANIZATION_NAME, ACCOUNT_NAME, ACCOUNT_LOCATOR, REGION, USAGE_DATE, 
    CREDITS_USED, TABLE_ID, TABLE_NAME, SCHEMA_ID, SCHEMA_NAME, DATABASE_ID, 
    DATABASE_NAME 
    from SNOWFLAKE.organization_usage.SEARCH_OPTIMIZATION_HISTORY;
create or replace view stitcherai.source_data.REPLICATION_USAGE_HISTORY 
as select ORGANIZATION_NAME, ACCOUNT_NAME, ACCOUNT_LOCATOR, REGION, USAGE_DATE, 
    DATABASE_ID, DATABASE_NAME, CREDITS_USED, BYTES_TRANSFERRED 
    from SNOWFLAKE.organization_usage.REPLICATION_USAGE_HISTORY;
create or replace view stitcherai.source_data.STORAGE_DAILY_HISTORY
as select SERVICE_TYPE, ORGANIZATION_NAME, ACCOUNT_NAME, USAGE_DATE, AVERAGE_BYTES, 
    REGION, ACCOUNT_LOCATOR, CREDITS
    from SNOWFLAKE.organization_usage.STORAGE_DAILY_HISTORY;


---------------------------------------------------------------------------------------------------
-- Step 5: Grant access to the user & role created above
-- Grant read access to the tables and views in the schema created above
---------------------------------------------------------------------------------------------------
grant usage on integration IDENTIFIER($gcs_integration_name) to role IDENTIFIER($stitcherai_reader_role);
grant usage on database IDENTIFIER($database_for_reads) to role IDENTIFIER($stitcherai_reader_role);
grant usage on schema IDENTIFIER($fq_schema) to role IDENTIFIER($stitcherai_reader_role);
grant select on all views in schema IDENTIFIER($fq_schema) to role IDENTIFIER($stitcherai_reader_role);
grant select on all tables in schema IDENTIFIER($fq_schema) to role IDENTIFIER($stitcherai_reader_role);
grant select on future views in schema IDENTIFIER($fq_schema) to role IDENTIFIER($stitcherai_reader_role);
grant select on future tables in schema IDENTIFIER($fq_schema) to role IDENTIFIER($stitcherai_reader_role);


---------------------------------------------------------------------------------------------------
-- Step 6: -- **** IMPORTANT **** --
-- Record the value of the 'STORAGE_GCP_SERVICE_ACCOUNT' key from the result of the command below
---------------------------------------------------------------------------------------------------
DESC STORAGE INTEGRATION IDENTIFIER($gcs_integration_name);
```

## Business Data Access (Optional)

For business datasets stored in Snowflake, execute Steps 4 and 5 in the script, referencing the database and schema where the business data is stored. It is recommended to create a separate schema under the same StitcherAI database as the cost data.

## Creating the Data Source in the StitcherAI UI

Navigate to the [Data Sources](https://app.stitcher.ai/connections/datasources) page in the StitcherAI web app and create a new data source for **Snowflake cost data**. Input the credentials recorded in the steps above. Once created, validate the connection by clicking **Validate connection** in the row actions, or use the **Validate all connections** button at the top of the table.

## Need Help?

Please contact [support@stitcher.ai](mailto:support@stitcher.ai) for assistance in setting up Snowflake access.
