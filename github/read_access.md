# GitHub Enterprise Cost and Usage Data Access for StitcherAI

To enable StitcherAI to build a comprehensive cost model for your organization, access to GitHub Enterprise usage and metering data via the GitHub REST API is required. This document provides a step-by-step guide on how to grant the necessary access to StitcherAI using a personal access token.

> **TODO:** State what StitcherAI reads, and whether the `manage_billing:enterprise` scope also permits write actions.

## Prerequisites

- A GitHub Enterprise Cloud or GitHub Enterprise Server account.

> **TODO:** Name the enterprise role required to create a token with the `manage_billing:enterprise` scope.

## Steps to Grant Access

1. Create a personal access token with the `manage_billing:enterprise` scope.
2. Copy the generated token.

> **TODO:** Replace step 1 with the console steps, and state whether a classic or fine-grained token is required.

**Important:** The token will only be displayed once. Store it securely.

## Other Information to Capture

- **Enterprise slug**: The slug of your enterprise as it appears in the enterprise URL, `github.com/enterprises/ENTERPRISE-SLUG`.
- **API base URL** (optional): `https://api.github.com` for GitHub Enterprise Cloud, or `https://HOSTNAME/api/v3` for GitHub Enterprise Server, where `HOSTNAME` is your server's hostname.

## Creating the Data Source in the StitcherAI UI

Navigate to the [Data Sources](https://app.stitcher.ai/connections/datasources) page in the StitcherAI web app and create a new data source for **GitHub**. Input the Personal access token and Enterprise slug captured above, and the API base URL if it applies. Once created, validate the connection by clicking **Validate connection** in the row actions, or use the **Validate all connections** button at the top of the table.

> **TODO:** Confirm the data source name shown in the StitcherAI UI.

## Need Help?

Please contact [support@stitcher.ai](mailto:support@stitcher.ai) for assistance in setting up GitHub cost and usage data access.
