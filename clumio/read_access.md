# Clumio Consumption Data Access for StitcherAI

To enable StitcherAI to build a comprehensive cost model for your organization, access to consumption data via the Clumio REST API is required. This document provides a step-by-step guide on how to grant the necessary access to StitcherAI using an API token.

StitcherAI reads only the Clumio **consumption report**, the daily credit-consumption history of the assets backed up by Clumio (asset, organizational unit, policy, storage tier, usage amounts, credit rates, and credits consumed). StitcherAI performs read operations only and never takes any other action on your account.

Clumio offers two kinds of API tokens:

- A **personal token** inherits the full permissions of the user who creates it and follows that user. If the user's role changes, the token's access changes with it. If the user is suspended or deleted, Clumio suspends or deletes the token too. Clumio intends personal tokens for development and testing.
- A **service token** (recommended) is created by an administrator with an explicitly chosen role and organizational unit. It is independent of its creator, so you can scope it down to read-only access. A service token can never have more permissions or OU access than the administrator who creates it.

Use a service token with the **Reporting/Audit Admin** role, the least-privileged built-in role that can view and generate reports, including the consumption report.

## Prerequisites

- An active Clumio account.
- A user with the **Super Admin** or **Organizational Unit (OU) Admin** role. Only these roles can create service tokens. Each user can create one personal token for themselves, but it carries that user's full permissions, so a service token is preferred.

## Steps to Grant Access

1. Log in to the Clumio UI and navigate to **Administration > Access Management > API Tokens**. Some Clumio versions label the first menu **Settings**. Most organizations log in at `https://portal.clumio.com`. See [Finding your region](#finding-your-region) for the other portals.
2. In the **Service Token** section, click **Generate API Token** and configure:
    - **Token name**: an identifiable name (e.g., `StitcherAI Consumption Access`). You cannot change the name later.
    - **Organizational Unit**: the OU whose consumption data StitcherAI should read, typically the top-level OU. Clumio hides this field if your account only has the lowest-level OU, which it then selects by default.
    - **Role**: **Reporting/Audit Admin**.
3. Click **Next**, then **Generate and Download**. Clumio downloads a CSV file that contains the token.

**Important:** You can download the CSV file only once. Store the token securely. Service tokens remain valid until you refresh or delete them on the same **API Tokens** page. Clumio recommends refreshing tokens every three months. Update the StitcherAI data source when you do.

## Other Information to Capture

- **API base URL**: The regional Clumio API endpoint your organization is hosted on, for example `https://us-west-2.api.clumio.com`.

### Finding your region

The Clumio portal you log in to determines your region and therefore the API base URL. Check the URL in your browser after you log in to Clumio:

| Portal login URL | API base URL |
| --- | --- |
| `https://portal.clumio.com` (US West) | `https://us-west-2.api.clumio.com` |
| `https://us2.portal.clumio.com` (US East) | `https://us-east-1.api.clumio.com` |
| `https://canada.portal.clumio.com` (Canada) | `https://ca-central-1.ca.api.clumio.com` |
| `https://eu1.portal.clumio.com` (Europe) | `https://eu-central-1.de.api.clumio.com` |
| `https://au.portal.clumio.com` (Australia) | `https://ap-southeast-2.au.api.clumio.com` |

If your portal is not in this table, or you are unsure which portal your organization is on, contact [support@clumio.com](mailto:support@clumio.com).

## Creating the Data Source in the StitcherAI UI

Navigate to the [Data Sources](https://app.stitcher.ai/connections/datasources) page in the StitcherAI web app and create a new data source for **Clumio**. Input the API token and API base URL captured above. Once created, validate the connection by clicking **Validate connection** in the row actions, or use the **Validate all connections** button at the top of the table.

## Need Help?

Please contact [support@stitcher.ai](mailto:support@stitcher.ai) for assistance in setting up Clumio consumption data access.
