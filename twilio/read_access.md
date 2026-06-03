# Twilio Cost and Usage Data Access for StitcherAI

To enable StitcherAI to build a comprehensive cost model for your organization, access to cost and usage data from Twilio is required, which is available via the Twilio Usage Records API. This document provides a step-by-step guide on how to grant the necessary access to StitcherAI using a Standard API key.

StitcherAI will never perform any write actions to your Twilio account. Note that Twilio does not currently support fine-grained permission scoping for usage and billing APIs. We recommend submitting a feature request to Twilio for improved permission scoping, and StitcherAI will adopt fine-grained permissions once they become available.

## Prerequisites

- An active Twilio account with **Administrator** or **Developer** role, which is required to create an API key.

## Account Scope Note

If you create an API key in your top-level main account, StitcherAI will include cost data from all subaccounts that roll up to that account. To capture costs for a specific subaccount only, create an API key scoped to that subaccount and connect it as a separate data source.

## Steps to Grant Access

1. Log in to the [Twilio console](https://console.twilio.com). Ensure you are logged in to your **main** Twilio account.
2. On the **Account Dashboard**, copy the **Account SID** displayed in the **Account Info** section.
3. At the top of the console, click **Admin > Account management**.
4. On the left navigation menu, under **Keys & Credentials**, click **API keys & tokens**.
5. Click **Create API key**.
6. Fill in the following details:
   - **Friendly name**: e.g., `StitcherAI Cost Access`
   - **Region**: select your region
   - **Key type**: select `Standard`
7. Click **Create**.
8. Capture the following information:
   - **API Key SID** (the string identifier for the key)
   - **API Secret**

**Important:** The API secret will only be shown once. Store it securely.

## Other Information to Capture

- **Account SID**: Copied in step 2 above. This is the top-level identifier for your Twilio account.

## Creating the Data Source in the StitcherAI UI

Navigate to the [Data Sources](https://app.stitcher.ai/connections/datasources) page in the StitcherAI web app and create a new data source for **Twilio cost data**. Input the API Key SID, API Secret, and Account SID captured above. Once created, validate the connection by clicking **Validate connection** in the row actions, or use the **Validate all connections** button at the top of the table.

## Need Help?

Please contact [support@stitcher.ai](mailto:support@stitcher.ai) for assistance in setting up Twilio cost and usage data access.
