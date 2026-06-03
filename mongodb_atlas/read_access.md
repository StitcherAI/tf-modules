# MongoDB Atlas Cost and Usage Data Access for StitcherAI

To enable StitcherAI to build a comprehensive cost model for your organization, access to cost and usage data from MongoDB Atlas is required, which is provided via the MongoDB admin APIs. This document provides a step-by-step guide on how to grant the necessary access to StitcherAI using an API key.

## Prerequisites

- An active MongoDB Atlas account with administrative privileges.

## Steps to Grant Access

1. Log in to the [MongoDB Atlas console](https://cloud.mongodb.com).
2. Navigate to the **Access Manager** menu and select **Organizational Access**.
3. Under the Organizational Access Manager, click **Application Access** and select the **API Keys** section.
4. Click **Add New** and select the **API Key** menu item.
5. Fill in the description field.
6. Grant the following roles to the StitcherAI API key:
   - `Organization Billing Viewer`
   - `Organization Read Only`
7. Create the API key.
8. Capture the following information:
   - Public API key
   - Private API key

**Important**: The private API key will only be displayed once. Store it securely.

## Other Information to Capture

- **Organization ID**: Capture the MongoDB Organization ID, available in the organization settings page of the [MongoDB Atlas console](https://cloud.mongodb.com).

## Creating the Data Source in the StitcherAI UI

Navigate to the [Data Sources](https://app.stitcher.ai/connections/datasources) page in the StitcherAI web app and create a new data source for **MongoDB Atlas cost data**. Input the information captured above. Once created, validate the connection by clicking **Validate connection** in the row actions, or use the **Validate all connections** button at the top of the table.

## Need Help?

Please contact [support@stitcher.ai](mailto:support@stitcher.ai) for assistance in setting up MongoDB Atlas cost and usage data access.
