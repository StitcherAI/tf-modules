# OpenAI Cost and Usage Data Access for StitcherAI

To enable StitcherAI to build a comprehensive cost model for your organization, access to cost and usage data via the OpenAI Costs API is required. This document provides a step-by-step guide on how to grant the necessary access to StitcherAI using a read-only Admin Key.

StitcherAI does not perform any actions that incur costs. Note that OpenAI requires an Admin Key to access the Costs API — the read-only permission level is available when creating the key, and StitcherAI will use strictly read-only access.

## Prerequisites

- An active OpenAI account with **Organization Owner** role, which is required to create an Admin Key.

## Steps to Grant Access

1. Navigate to the **Admin Keys** page of the [OpenAI console](https://platform.openai.com) and log in using your company email.
2. Click **+ Create new Admin key**.
3. Enter an identifiable name for the key (e.g., `StitcherAI Cost Access`).
4. For **Permissions**, select **Read only**.
5. Click **Create admin key** and copy the generated key.

**Important:** The key will only be displayed once. Store it securely.

## Creating the Data Source in the StitcherAI UI

Navigate to the [Data Sources](https://app.stitcher.ai/connections/datasources) page in the StitcherAI web app and create a new data source for **OpenAI cost data**. Input the Admin Key captured above. Once created, validate the connection by clicking **Validate connection** in the row actions, or use the **Validate all connections** button at the top of the table.

## Need Help?

Please contact [support@stitcher.ai](mailto:support@stitcher.ai) for assistance in setting up OpenAI cost and usage data access.
