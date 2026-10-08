# RunPod Cost and Usage Data Access for StitcherAI

To enable StitcherAI to build a comprehensive cost model for your organization, access to cost and usage data via the RunPod API is required. This document provides a step-by-step guide on how to grant the necessary access to StitcherAI using an API key.

> **TODO:** State what StitcherAI reads, and whether RunPod offers a read-only permission level for API keys.

## Prerequisites

- An active RunPod account.

> **TODO:** Name the account role required to create an API key.

## Steps to Grant Access

1. Log in to the [RunPod console](https://console.runpod.io) and navigate to **Settings > API Keys**.
2. Create a new API key with an identifiable name (e.g., `StitcherAI Cost Access`).
3. Copy the generated key. RunPod API keys start with `rpa_`.

> **TODO:** Add the permission level to select in step 2.

**Important:** The key will only be displayed once. Store it securely.

## Creating the Data Source in the StitcherAI UI

Navigate to the [Data Sources](https://app.stitcher.ai/connections/datasources) page in the StitcherAI web app and create a new data source for **RunPod**. Input the API Key captured above. Once created, validate the connection by clicking **Validate connection** in the row actions, or use the **Validate all connections** button at the top of the table.

> **TODO:** Confirm the data source name shown in the StitcherAI UI.

## Need Help?

Please contact [support@stitcher.ai](mailto:support@stitcher.ai) for assistance in setting up RunPod cost and usage data access.
