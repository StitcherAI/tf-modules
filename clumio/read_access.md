# Clumio Consumption Data Access for StitcherAI

To enable StitcherAI to build a comprehensive cost model for your organization, access to consumption data via the Clumio REST API is required. This document provides a step-by-step guide on how to grant the necessary access to StitcherAI using an API token.

> **TODO:** State what StitcherAI reads, and whether the token inherits the full permissions of the user who creates it.

## Prerequisites

- An active Clumio account.

> **TODO:** Name the role required to create an API token, and the least-privileged role that can read consumption data.

## Steps to Grant Access

1. Log in to the Clumio UI and navigate to **Settings > API Tokens**.
2. Create a new API token with an identifiable name (e.g., `StitcherAI Consumption Access`).
3. Copy the generated token.

> **TODO:** Add the Clumio UI URL and any options to select in step 2.

**Important:** The token will only be displayed once. Store it securely.

## Other Information to Capture

- **API base URL**: The regional Clumio API endpoint your organization is hosted on, for example `https://us-west-2.api.clumio.com`.

> **TODO:** Explain how to find the region of a Clumio organization.

## Creating the Data Source in the StitcherAI UI

Navigate to the [Data Sources](https://app.stitcher.ai/connections/datasources) page in the StitcherAI web app and create a new data source for **Clumio**. Input the API token and API base URL captured above. Once created, validate the connection by clicking **Validate connection** in the row actions, or use the **Validate all connections** button at the top of the table.

> **TODO:** Confirm the data source name shown in the StitcherAI UI.

## Need Help?

Please contact [support@stitcher.ai](mailto:support@stitcher.ai) for assistance in setting up Clumio consumption data access.
