# Snowflake Write Access for StitcherAI Datasets

Customers can choose to use Snowflake as their data warehouse to receive cost datasets and custom artifacts produced by StitcherAI. To do this, set up a Snowflake destination on the [Destinations](https://app.stitcher.ai/connections/destinations) page in the StitcherAI web app.

## Providing StitcherAI Write Access

To grant write access to StitcherAI, please review and execute the steps below.

### Authentication

The destination connection authenticates with one of two mechanisms — the same choice as the [read connections](./read-access.md):

- **Programmatic access token (PAT)** — the Snowflake username plus a PAT. Created in Step 3, **Option A** below.
- **Key pair** — the Snowflake username plus an RSA private key, with the matching public key registered on the Snowflake user (recommended for service accounts). Created in Step 3, **Option B** below.

Select the mechanism in the StitcherAI UI via the **Authentication method** field and provide the matching credential — the PAT (as the password) or the private key. Run only one of the two options in the script.

**Before running the script, please review and update the variables in Step 1**:

- Find the StitcherAI environment ID you're granting access to (available in the [StitcherAI web app](https://app.stitcher.ai/environments)).
- Specify a username.
- Specify the warehouse size.

**The script performs the following actions**:

1. Sets up the user, role, database, etc. and configures authentication (a PAT or a key pair).
2. Creates the table where you want the data loaded.
3. Grants the necessary privileges to the user and role created in Step 1 to write to the table created in Step 2.

**Important**: Record the following data so the StitcherAI destination can be created on the [Destinations](https://app.stitcher.ai/connections/destinations) page:

- Authentication credentials — depending on the option you ran in Step 3:
  - **PAT (Option A)**: the Snowflake username and the token (PAT)
  - **Key pair (Option B)**: the Snowflake username and the RSA **private** key (plus its passphrase, only if you created an encrypted key)
- Step 1 values for optional keys (only needed if the default values are not used)
  - Database name (`database_for_writes`)
  - Schema name (`schema_for_writes`)
  - Export table name (`export_table_name`)
  - Write role (`stitcherai_writer_role`)
  - Warehouse name (`stitcherai_warehouse`)
  - GCS integration name (`gcs_integration_name`)
- Step 7 output for key `STORAGE_GCP_SERVICE_ACCOUNT`

```sql
-- SQL script for setting up Snowflake write access for StitcherAI

----------------------------------------------------------------------------------------------------
-- Step 1: Fill variables
-- Provide all necessary information for the setup (names for users, roles, database/schema, etc.)
-- More information above in the section:
--   "Before running the script, please review and update the variables in Step 1:"
----------------------------------------------------------------------------------------------------

set stitcherai_environment_id='??'; -- Replace with environment id (see above section 'Before running the script, please review and update the variables in Step 1')
set stitcherai_user='stitcherai';
set database_for_writes ='stitcherai';
set schema_for_writes = 'cost_data';
set export_table_name = 'stitcherai';
set stitcherai_warehouse_size='SMALL';

set stitcherai_writer_role='stitcherai_writer';
set stitcherai_warehouse='stitcherai';
set gcs_integration_name = 'stitcherai_gcs_int';
set fq_schema = concat($database_for_writes, '.', $schema_for_writes);
set fq_table = concat($fq_schema, '.', $export_table_name);

use role accountadmin;

---------------------------------------------------------------------------------------------------
-- Step 2: Create supporting objects
-- Create the role, warehouse, and database/schema that the StitcherAI user will use.
---------------------------------------------------------------------------------------------------
create role IDENTIFIER($stitcherai_writer_role);

create or replace warehouse IDENTIFIER($stitcherai_warehouse)
    AUTO_SUSPEND=60
    INITIALLY_SUSPENDED=TRUE
    WAREHOUSE_SIZE=$stitcherai_warehouse_size;
    
grant all on warehouse IDENTIFIER($stitcherai_warehouse) to role IDENTIFIER($stitcherai_writer_role);

create database if not exists IDENTIFIER($database_for_writes);
create schema if not exists IDENTIFIER($fq_schema);
grant select on all tables in schema IDENTIFIER($fq_schema) to role IDENTIFIER($stitcherai_writer_role);

---------------------------------------------------------------------------------------------------
-- Step 3: Create the StitcherAI user (principal) and configure authentication
-- Create the service user and set up ONE authentication method (Option A or Option B below).
-- Every step after this one grants the user access and is identical regardless of the method
-- you choose here.
---------------------------------------------------------------------------------------------------
CREATE USER IDENTIFIER($stitcherai_user)
    DEFAULT_WAREHOUSE=$stitcherai_warehouse
    DEFAULT_ROLE=$stitcherai_writer_role;

grant role IDENTIFIER($stitcherai_writer_role) to user IDENTIFIER($stitcherai_user);

-- **** AUTHENTICATION: run EITHER Option A (PAT) OR Option B (key pair), not both ****

-- =================================================================================================
-- Option A: Programmatic access token (PAT)
-- =================================================================================================
-- Update as needed to meet your organization's security policies. The authentication policy below has default values
-- Use this default network policy if your organization doesn't have a default policy it applies to accounts.
-- If IP restrictions are necessary, please notify your StitcherAI contact so we can provide the subnets StitcherAI
-- will connect from. The user access required here is limited and may not require additional policies for the token
USE DATABASE IDENTIFIER($database_for_writes);

CREATE AUTHENTICATION POLICY stitcher_authentication_policy
  PAT_POLICY=(
    NETWORK_POLICY_EVALUATION = ENFORCED_NOT_REQUIRED
    MAX_EXPIRY_IN_DAYS=365
    DEFAULT_EXPIRY_IN_DAYS=30
  );

ALTER USER IDENTIFIER($stitcherai_user) SET AUTHENTICATION POLICY stitcher_authentication_policy;

-- **** IMPORTANT **** --
-- SAVE the personal access token (PAT) generated from the command below. This will be needed
-- to set up the snowflake connection in the StitcherAI WebUI in a subsequent step.
ALTER USER IF EXISTS IDENTIFIER($stitcherai_user) ADD PROGRAMMATIC ACCESS TOKEN stitcher_pat 
  DAYS_TO_EXPIRY = 365;

-- =================================================================================================
-- Option B: Key-pair authentication (use INSTEAD of Option A)
-- =================================================================================================
-- 1. Generate an UNENCRYPTED RSA key pair locally. An empty passphrase still produces an *encrypted*
--    key that will fail to load, so use -nocrypt:
--      openssl genrsa 2048 | openssl pkcs8 -topk8 -nocrypt -out stitcher_rsa_key.p8
--      openssl rsa -in stitcher_rsa_key.p8 -pubout -out stitcher_rsa_key.pub
--    (To use an encrypted key instead, omit -nocrypt and supply the passphrase in the StitcherAI UI.)
-- 2. Register the PUBLIC key on the user. Paste the key body only -- drop the
--    "-----BEGIN/END PUBLIC KEY-----" lines and any line breaks:
ALTER USER IDENTIFIER($stitcherai_user) SET RSA_PUBLIC_KEY='<public key body, no header/footer>';
-- 3. Keep the PRIVATE key file (stitcher_rsa_key.p8). You'll paste its contents into the StitcherAI UI
--    (Authentication method = Key pair), where it is stored in the secure vault.


---------------------------------------------------------------------------------------------------
-- Step 4: Setup GCS integration
-- Setup the Google Cloud Storage integration for StitcherAI to load the StitcherAI dataset into
-- the customer specified table
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
-- Step 5: Create the StitcherAI destination table
-- Create the table that StitcherAI will write cost data into.
-- Contact your StitcherAI representative for the complete table schema.
---------------------------------------------------------------------------------------------------
create table IDENTIFIER($fq_table) (
    "BillingAccountId" VARCHAR(16777216),
    "BillingAccountName" VARCHAR(16777216),
    "BillingPeriodStart" TIMESTAMP_LTZ(9),
    "BillingPeriodEnd" TIMESTAMP_LTZ(9),
    "ChargePeriodStart" TIMESTAMP_LTZ(9),
    "ChargePeriodEnd" TIMESTAMP_LTZ(9),
    -- ...
    -- Fill with the actual schema of the StitcherAI dataset. Contact support for help
    -- Snowflake doesn't allow for the schema to be created on load (it provides some schema
    -- evolution abilities, but only 10 columns can be evolved at a time automatically)
);

---------------------------------------------------------------------------------------------------
-- Step 6: Grant access to the user & role created above
-- Grant access to read/write from the tables and schemas created above for the user & role above
---------------------------------------------------------------------------------------------------

grant usage on integration IDENTIFIER($gcs_integration_name) to role IDENTIFIER($stitcherai_writer_role);
grant usage on database IDENTIFIER($database_for_writes) to role IDENTIFIER($stitcherai_writer_role);
grant usage on schema IDENTIFIER($fq_schema) to role IDENTIFIER($stitcherai_writer_role);
grant select on all tables in schema IDENTIFIER($fq_schema) to role IDENTIFIER($stitcherai_writer_role);
grant insert on all tables in schema IDENTIFIER($fq_schema) to role IDENTIFIER($stitcherai_writer_role);
grant delete on all tables in schema IDENTIFIER($fq_schema) to role IDENTIFIER($stitcherai_writer_role);
grant evolve schema on all tables in schema IDENTIFIER($fq_schema) to role IDENTIFIER($stitcherai_writer_role);

---------------------------------------------------------------------------------------------------
-- Step 7: -- **** IMPORTANT **** --
-- Record the value of the 'STORAGE_GCP_SERVICE_ACCOUNT' key from the result of the command below
---------------------------------------------------------------------------------------------------
DESC STORAGE INTEGRATION IDENTIFIER($gcs_integration_name);
```

**Note**: Fill the actual schema of the StitcherAI dataset in Step 5. Contact [support@stitcher.ai](mailto:support@stitcher.ai) for help.

## Creating the Destination in the StitcherAI UI

Navigate to the [Destinations](https://app.stitcher.ai/connections/destinations) page in the StitcherAI web app and create a new Snowflake destination. Set **Authentication method** to match the option you ran in Step 3 — **Password** for a PAT (enter the PAT as the password) or **Key pair** (paste the private key, and the passphrase only if your key is encrypted) — then input the remaining credentials recorded in the steps above. Once created, validate the connection by clicking **Validate connection** in the row actions, or use the **Validate all connections** button at the top of the table.

## Need Help?

Please contact [support@stitcher.ai](mailto:support@stitcher.ai) for assistance in setting up Snowflake write access.
