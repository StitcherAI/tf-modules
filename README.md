# StitcherAI Terraform Modules & Provider Setup Guides

This repository contains Terraform modules and setup guides for granting [StitcherAI](https://app.stitcher.ai) access to cost and usage data across your cloud infrastructure and SaaS providers.

## Overview

StitcherAI requires two types of access to operate: read access to cost and business data from the providers you use, and write access to deliver enriched cost datasets, custom artifacts, and insights back to your chosen destinations. This repository provides the resources needed to grant both types of access, organized by provider:

- **Terraform modules** — for cloud providers (AWS, Azure, GCP) and Databricks, where access is granted by provisioning infrastructure such as IAM roles and storage bindings.
- **Setup guides** — for SaaS and API providers, where access is granted by creating an API key or service account through the provider's web console.

Your StitcherAI environment ID is required for most setups. You can find it at [app.stitcher.ai/environments](https://app.stitcher.ai/environments).

---

## Providers

### Cloud Infrastructure (Terraform)

| Provider | Directory | Description |
|---|---|---|
| AWS | [`aws/`](./aws/) | IAM role for cross-account access, S3 read/export policies, CUR describe policy |
| Azure | [`azure/`](./azure/) | Azure AD application for federated access, Blob Store read/export bindings |
| GCP | [`gcp/`](./gcp/) | BigQuery and GCS read/export IAM bindings, IAM role |

### SaaS & API Providers (Setup Guides)

| Provider | Directory | Guide |
|---|---|---|
| Snowflake | [`snowflake/`](./snowflake/) | SQL scripts for cost read access and optional write access for StitcherAI datasets (PAT or key-pair authentication) |
| Confluent Cloud | [`confluent_cloud/`](./confluent_cloud/) | API key setup for cost and usage data access |
| Elastic Cloud | [`elastic_cloud/`](./elastic_cloud/) | API key setup for cost and usage data access |
| MongoDB Atlas | [`mongodb_atlas/`](./mongodb_atlas/) | Admin API key setup for cost and usage data access |
| Twilio | [`twilio/`](./twilio/) | Standard API key setup for cost and usage data access |
| OpenAI | [`openai/`](./openai/) | Read-only Admin Key setup for cost and usage data access |
| Anthropic | [`anthropic/`](./anthropic/) | Admin API key setup for cost and usage data access |

---

## Using the Terraform Modules

### Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) v1.0 or later
- Credentials for the target cloud provider configured in your environment
- Your StitcherAI environment ID (available at [app.stitcher.ai/environments](https://app.stitcher.ai/environments))

### Usage

Reference the modules directly from this repository in your Terraform configuration. Each module directory contains a `variables.tf` describing the required inputs. For example, to set up the AWS IAM role:

```hcl
module "stitcherai_aws_role" {
  source = "github.com/StitcherAI/tf-modules//aws/iam-role"

  customer_iam_role_name         = "stitcherai-access-role"
  stitcher_aws_iam_principal_arn = "<provided by StitcherAI>"
  customer_external_id           = "<provided by StitcherAI>"
}
```

The values for StitcherAI-provided inputs (such as principal ARNs and external IDs) are available in the StitcherAI web app when setting up a data source or destination.

Each cloud provider typically requires more than one module — for example, AWS requires the IAM role plus one or more policy modules depending on where your billing data lives. Refer to the subdirectory README or contact [support@stitcher.ai](mailto:support@stitcher.ai) for guidance on which modules apply to your setup.

---

## Using the Setup Guides

For SaaS providers, open the `read_access.md` (or `write-access.md` for Snowflake destinations) in the relevant provider directory and follow the step-by-step instructions. Each guide covers:

1. **Prerequisites** — the role or permission level required in the provider's console
2. **Steps to grant access** — how to create the API key or credentials
3. **Creating the data source** — how to enter the credentials into the StitcherAI web app

Once a connection is created in StitcherAI, you can verify it is working by clicking **Validate connection** in the row actions on the [Data Sources](https://app.stitcher.ai/connections/datasources) or [Destinations](https://app.stitcher.ai/connections/destinations) page, or by using the **Validate all connections** button at the top of the table.

---

## Need Help?

Contact [support@stitcher.ai](mailto:support@stitcher.ai) for assistance with any of the modules or setup guides in this repository.
