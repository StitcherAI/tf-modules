# Anthropic Cost and Usage Data Access for StitcherAI

To enable StitcherAI to build a comprehensive cost model for your organization, access to cost and usage data via the Anthropic Usage and Cost API is required. This document provides a step-by-step guide on how to grant the necessary access to StitcherAI using an Admin API key.

StitcherAI will only perform read operations against the Usage and Cost API and will never perform any other actions on your account.

**Important:** Anthropic currently requires an Admin API key to access the Usage and Cost API. Admin API keys carry broad access with no option for finer permission scoping at this time. StitcherAI will adopt a read-only role as soon as Anthropic makes one available, and we recommend working with your account representative to submit a feature request to Anthropic to prioritize this. Only usage data (e.g., token consumption) is ingested by StitcherAI.

**Note:** This integration is for direct Anthropic API usage only. It does not support Claude hosted on other cloud providers (e.g., Amazon Bedrock) or subscription and seat-based costs (e.g., Claude Team, Claude Code, or Claude.ai consumer plans).

**Note:** Tax information is not currently surfaced by the Anthropic API and is therefore not included in cost data.

## Prerequisites

- An active Anthropic account with **Organization Admin** role. Admin API keys are not available for individual accounts — you must have an organization configured in the Anthropic console before proceeding (navigate to **Console > Settings > Organization** to set one up).

## Steps to Grant Access

1. Log in to the [Anthropic console](https://console.anthropic.com).
2. On the bottom left of the console, click your username, then select **Organization settings**.
3. On the left navigation, click **Admin keys**.
4. Click **+ Create admin key**.
5. Enter a name for the key (e.g., `StitcherAI Cost Access`) and click **Add**.
6. Copy the newly created key. Admin keys start with `sk-ant-admin`.

**Important:** The key will only be displayed once. Store it securely.

## Creating the Data Source in the StitcherAI UI

Navigate to the [Data Sources](https://app.stitcher.ai/connections/datasources) page in the StitcherAI web app and create a new data source for **Anthropic cost data**. Input the Admin API key captured above. Once created, validate the connection by clicking **Validate connection** in the row actions, or use the **Validate all connections** button at the top of the table.

## Need Help?

Please contact [support@stitcher.ai](mailto:support@stitcher.ai) for assistance in setting up Anthropic cost and usage data access.
