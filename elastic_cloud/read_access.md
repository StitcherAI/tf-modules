# Elastic Cloud Cost and Usage Data Access for StitcherAI

To enable StitcherAI to build a comprehensive cost model for your organization, access to cost and usage data from Elastic Cloud is required, which is available via the Elastic Cloud API. This document provides a step-by-step guide on how to grant the necessary access to StitcherAI using an API key.

## Prerequisites

An active Elastic Cloud account with administrative privileges.

## Steps to Grant Access

1. Log in to the [Elastic Cloud console](https://cloud.elastic.co).
2. Navigate to **Organization > API Keys** from the left-hand menu.
3. Click on **Create API key**.
4. Provide a name for the API key (e.g., `StitcherAI Cost Access`).
5. Assign the **Billing Admin** role and set the key to not expire.
6. Create the API key.
7. Capture the following information:
   - API Key ID

**Important:** The API key value will only be displayed once upon creation. Make sure to store it securely.

## Other Information to Capture

- **Organization ID**: This identifier is often required for billing API calls. You can find it in your Elastic Cloud console under **Account**. It is a 9-digit number available on the top header of the [Members page](https://cloud.elastic.co/account/members).

## Creating the Data Source in the StitcherAI UI

Navigate to the [Data Sources](https://app.stitcher.ai/connections/datasources) page in the StitcherAI web app and create a new data source for **Elastic Cloud cost data**. Input the information captured above. Once created, validate the connection by clicking **Validate connection** in the row actions, or use the **Validate all connections** button at the top of the table.

## Need Help?

Please contact [support@stitcher.ai](mailto:support@stitcher.ai) for assistance in setting up Elastic Cloud cost and usage data access.
