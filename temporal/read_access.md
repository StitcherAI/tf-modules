# Temporal Cloud Cost and Usage Data Access for StitcherAI

To enable StitcherAI to build a comprehensive cost model for your organization, access to cost and usage data via the Temporal Cloud API is required. This document provides a step-by-step guide on how to grant the necessary access to StitcherAI using an API key.

> **TODO:** State what StitcherAI reads, and whether the key belongs to a user or a service account.

## Prerequisites

- An active Temporal Cloud account.

> **TODO:** Name the account role required to create the API key, and the account role the key needs to read billing data (for example, Finance Admin or Read-Only).

## Steps to Grant Access

1. Create a Temporal Cloud API key.
2. Copy the generated key.

> **TODO:** Replace step 1 with the console steps, including any service account setup.

**Important:** The key will only be displayed once. Store it securely.

## Creating the Data Source in the StitcherAI UI

Navigate to the [Data Sources](https://app.stitcher.ai/connections/datasources) page in the StitcherAI web app and create a new data source for **Temporal**. Input the API Key captured above. Once created, validate the connection by clicking **Validate connection** in the row actions, or use the **Validate all connections** button at the top of the table.

> **TODO:** Confirm the data source name shown in the StitcherAI UI.

## Need Help?

Please contact [support@stitcher.ai](mailto:support@stitcher.ai) for assistance in setting up Temporal Cloud cost and usage data access.
