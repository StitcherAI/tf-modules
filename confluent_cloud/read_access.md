# Confluent Cloud Cost and Usage Data Access for StitcherAI

To enable StitcherAI to build a comprehensive cost model for your organization, access to cost and usage data from Confluent Cloud is required, which is available via the Confluent Cloud Billing and Usage APIs. This document provides a step-by-step guide on how to grant the necessary access to StitcherAI using a service account and API key.

## Prerequisites

An active Confluent Cloud account with **OrganizationAdmin** privileges.

## Steps to Grant Access

1. Log in to your [Confluent Cloud Console](https://confluent.cloud).
2. (Optional) Navigate to **Administration > Accounts** and create an account for Billing or Stitcher.
3. Navigate to **Administration > API Keys**.
4. Click on **+ Add API Key**.
5. Select the following scope for the API key:
   - `Cloud resource management`
6. Provide a name (e.g., `StitcherAI Billing Access`) and an optional description.
7. Click **Create**.
8. Capture the following information:
   - API Key
   - API Secret

**Important:** The API secret will only be shown once. Store it securely.

## Other Information to Capture

- **Organization key**: Unfortunately, Confluent Cloud does not have a public API for getting invoice details. This undocumented API is needed to consistently capture necessary details like cluster names and environment names, since those resources may be deleted by the time the billing data is retrieved. In order to call the invoices API, a separate organization key is needed, which can only be found in the browser on the developer console when accessing the invoices page of the Confluent web portal. Please contact [support@stitcher.ai](mailto:support@stitcher.ai) for assistance finding this value. Without this, StitcherAI will need to depend on the live resource APIs, which will not provide necessary details for deleted resources.

## Creating the Data Source in the StitcherAI UI

Navigate to the [Data Sources](https://app.stitcher.ai/connections/datasources) page in the StitcherAI web app and create a new data source for **Confluent Cloud cost data**. Input the captured API Key, API Secret, and Organization Key if found. Once created, validate the connection by clicking **Validate connection** in the row actions, or use the **Validate all connections** button at the top of the table.

## Need Help?

Please contact [support@stitcher.ai](mailto:support@stitcher.ai) for assistance in setting up Confluent Cloud cost and usage data access.
