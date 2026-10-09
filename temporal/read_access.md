# Temporal Cloud Cost and Usage Data Access for StitcherAI

To enable StitcherAI to build a comprehensive cost model for your organization, access to cost and usage data via the Temporal Cloud API is required. This document provides a step-by-step guide on how to grant the necessary access to StitcherAI using an API key.

The API key belongs to a dedicated service account with the **Finance Admin** account role, not to an individual user.

> **TODO:** State what StitcherAI reads.

## Prerequisites

- An active Temporal Cloud account.

> **TODO:** Name the account role required to create a service account and its API key.

## Steps to Grant Access

### Step 1: Create the service account

1. Sign in to the Temporal Cloud UI.
2. In the left menu, navigate to **Identities**, then select **Service Accounts**.
3. Click **Create Service Account**.
4. Enter a **Name** (e.g., `StitcherAI Cost Access`) and an optional **Description**.
5. In the **Account Level Role** dropdown, select **Finance Admin**.
6. Click **Create Service Account** at the bottom of the page.

### Step 2: Generate the API key

Temporal Cloud prompts you to generate an API key after it creates the service account. To do this later, go to **Settings > API Keys**.

1. Click **Create API Key**.
2. Under **Create an API key for**, select **Service Account**.
3. In the **Mapped to identity** search box, select the service account you created in step 1.
4. Enter an API key name, an optional description, and an **Expiration** date. Temporal Cloud allows an expiration of up to two years.
5. Click **Generate API Key** and copy the generated key.

**Important:** The key will only be displayed once. Store it securely, for example in a secrets manager.

**Note:** Before the key expires, generate a new one and update the StitcherAI data source, or the connection will stop working.

## Creating the Data Source in the StitcherAI UI

Navigate to the [Data Sources](https://app.stitcher.ai/connections/datasources) page in the StitcherAI web app and create a new data source for **Temporal**. Input the API Key captured above. Once created, validate the connection by clicking **Validate connection** in the row actions, or use the **Validate all connections** button at the top of the table.

> **TODO:** Confirm the data source name shown in the StitcherAI UI.

## Need Help?

Please contact [support@stitcher.ai](mailto:support@stitcher.ai) for assistance in setting up Temporal Cloud cost and usage data access.
