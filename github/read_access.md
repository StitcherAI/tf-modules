# GitHub Enterprise Cost and Usage Data Access for StitcherAI

To enable StitcherAI to build a comprehensive cost model for your organization, access to GitHub Enterprise usage and metering data via the GitHub REST API is required. This document provides a step-by-step guide on how to grant the necessary access to StitcherAI using a personal access token.

StitcherAI reads your enterprise's billing data from the GitHub billing platform endpoints:

- The detailed usage report: per-day metered usage by organization and repository.
- The Copilot AI credit and premium request usage reports.
- The list of cost centers used to attribute usage.

StitcherAI performs read operations on billing data only, apart from triggering GitHub's own usage-report generation when it validates the connection. It never accesses your code, repositories, members, or any other enterprise data.

**About the `manage_billing:enterprise` scope:** GitHub defines this scope as "read and write enterprise billing data". No personal access token scope grants read-only access to enterprise billing, so the token could also create or change budgets and cost centers. StitcherAI never does. A scope grants nothing beyond the access of the user who owns the token.

## Prerequisites

- A GitHub Enterprise Cloud account. GitHub Enterprise Server does not provide the billing usage endpoints StitcherAI reads.
- A user who is an **enterprise owner** or a **billing manager** of the enterprise to own the token. A **billing manager** is the least-privileged choice, because the role grants access to the enterprise's billing settings only.
- An enterprise personal access token policy that allows classic personal access tokens.

## Steps to Grant Access

GitHub's billing usage endpoints do not support fine-grained personal access tokens, so you must create a **classic** personal access token.

1. Sign in to GitHub as an enterprise owner or billing manager, click your profile picture, and select **Settings**.
2. Navigate to **Developer settings > Personal access tokens > Tokens (classic)**, or go directly to [github.com/settings/tokens](https://github.com/settings/tokens).
3. Click **Generate new token > Generate new token (classic)**.
4. Enter an identifiable note (e.g., `StitcherAI Cost Access`), choose an expiration, and select only the **`manage_billing:enterprise`** scope.
5. Click **Generate token** and copy the generated token. It starts with `ghp_`.

**Important:** Copy the token before you leave the page, and store it securely.

**Note:** If you set an expiration date, regenerate the token and update the StitcherAI data source before it lapses, or the connection will stop working.

## Other Information to Capture

- **Enterprise slug**: The slug of your enterprise as it appears in the enterprise URL, `github.com/enterprises/ENTERPRISE-SLUG`.
- **API base URL** (optional): `https://api.github.com` by default. For GitHub Enterprise Cloud with data residency (GHE.com), use `https://api.SUBDOMAIN.ghe.com`, where `SUBDOMAIN` is your enterprise's subdomain.

## Creating the Data Source in the StitcherAI UI

Navigate to the [Data Sources](https://app.stitcher.ai/connections/datasources) page in the StitcherAI web app and create a new data source for **GitHub**. Input the Personal access token and Enterprise slug captured above, and the API base URL if it applies. Once created, validate the connection by clicking **Validate connection** in the row actions, or use the **Validate all connections** button at the top of the table.

## Need Help?

Please contact [support@stitcher.ai](mailto:support@stitcher.ai) for assistance in setting up GitHub cost and usage data access.
