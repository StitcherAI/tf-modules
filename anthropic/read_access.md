# Anthropic Cost and Usage Data Access for StitcherAI

StitcherAI ingests Anthropic cost and usage data through two connectors. They
cover two different products — pick by where your usage lives:

- **[Claude Platform](#claude-platform-api-usage-based)** — your **developer
  API** usage on the Anthropic Platform (**platform.claude.com**): organization
  cost and token usage from the Usage and Cost API. This is the common case.
- **[Claude Enterprise](#claude-enterprise-user-seat-based)** — your **Claude
  Enterprise** seat usage on **claude.ai**: per-user cost and usage. Read via
  the Claude Analytics API. Only relevant if you have a Claude Enterprise plan.

If you call the Anthropic API (with `sk-ant-…` keys), you want **Claude
Platform**. If you want to see how your team uses Claude in the claude.ai app,
you want **Claude Enterprise**. They are independent — use either or both.

StitcherAI performs read operations only and never takes any other action on
your account.

---

## Claude Platform (API usage based)

> **Use this for your Anthropic developer API usage** — the API you access at
> **platform.claude.com** with `sk-ant-…` keys. This is *not* claude.ai seat
> usage (see [Claude Enterprise](#claude-enterprise-user-seat-based) for that).

Cost and token usage for your organization comes from the Anthropic Usage and
Cost API. Anthropic currently requires an **Admin API key** to access this API,
and Admin API keys carry broad access with no option for finer permission
scoping at this time. StitcherAI will adopt a read-only role as soon as
Anthropic makes one available, and we recommend asking your account
representative to submit a feature request to Anthropic to prioritize this.

**Note:** This covers direct Anthropic API usage only. It does not cover Claude
hosted on other cloud providers (e.g., Amazon Bedrock) or consumer/subscription
plans (e.g., Claude Team or Claude.ai). For Claude Enterprise seat usage, see
[Claude Enterprise](#claude-enterprise-user-seat-based).

**Note:** Tax information is not currently surfaced by the Anthropic API and is
therefore not included in cost data.

There are two ways to provide this data. **Option B is recommended** where the
broad scope of an Admin API key is a concern, because the key never leaves your
environment.

### Option A — Admin API key

StitcherAI calls the Usage and Cost API directly with an Admin API key you
provide.

**Prerequisites**

- An active Anthropic account with the **Organization Admin** role. Admin API
  keys are not available for individual accounts — an organization must be
  configured on the Anthropic Platform first (**Settings > Organization**).

**Steps**

1. Log in to the [Anthropic Platform](https://platform.claude.com)
   (`platform.claude.com`; `console.anthropic.com` redirects here).
2. On the bottom left, click your username, then select **Organization
   settings**.
3. On the left navigation, click **Admin keys**.
4. Click **+ Create admin key**.
5. Enter a name for the key (e.g., `StitcherAI Cost Access`) and click **Add**.
6. Copy the newly created key. Admin keys start with `sk-ant-admin`.

**Important:** The key will only be displayed once. Store it securely.

Then create the data source: on the
[Data Sources](https://app.stitcher.ai/connections/datasources) page, add a new
source for **Anthropic cost data**, input the Admin API key, and validate the
connection.

### Option B — File-based, key stays in your environment (recommended)

Because an Admin API key cannot be scoped, you can avoid sharing it with
StitcherAI entirely. In this model a reference agent runs on your own
infrastructure: it reads the Usage and Cost API with your Admin API key, writes
the cost and usage datasets to an object-store bucket you control (S3 or GCS),
and StitcherAI reads the **files** from that bucket. The Admin API key is used
only on your side and is never uploaded to StitcherAI.

The reference agent implementation is provided on request — **contact your
StitcherAI administrator** (or [support@stitcher.ai](mailto:support@stitcher.ai))
to obtain it and for help wiring it into your environment. At a high level:

1. Run the agent on a schedule. It stages the cost dataset, and optionally the
   usage dataset and workspace/API-key lists, under a dated path in your bucket.
2. Grant StitcherAI read access to that bucket path.
3. On the [Data Sources](https://app.stitcher.ai/connections/datasources) page,
   add a new source for **Anthropic cost data** using the file-based (S3 or GCS)
   connector, set the bucket and path, and validate the connection.

---

## Claude Enterprise (User seat based)

> **Use this for Claude Enterprise seat usage** — how your team uses Claude in
> the **claude.ai** app. This is *not* developer API usage (see
> [Claude Platform](#claude-platform-api-usage-based) for that), and it requires
> a Claude Enterprise plan.

This data is your per-user Claude Enterprise cost and usage. StitcherAI reads it
through the **Claude Analytics API** — the mechanism Anthropic provides for
Claude Enterprise usage. Unlike the Claude Platform Admin API, this API uses a
key with a dedicated read-only scope, so no broad access is granted.

**Prerequisites**

- A Claude Enterprise organization, and the **Primary Owner** role (required to
  create an Analytics API key).

**Steps**

1. Go to [claude.ai/analytics/api-keys](https://claude.ai/analytics/api-keys).
2. Create an API key with the **`read:analytics`** scope. This is not an Admin
   API key.
3. Copy the generated key and store it securely.

Then create the data source: on the
[Data Sources](https://app.stitcher.ai/connections/datasources) page, add a new
source for **Claude Enterprise**, input the Analytics API key, and validate the
connection. The organization is derived from the key, so no further parameters
are needed.

---

## Need Help?

Please contact [support@stitcher.ai](mailto:support@stitcher.ai) for assistance
in setting up Anthropic cost and usage data access.
