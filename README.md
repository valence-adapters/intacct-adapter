# Valence Ignore Records Filter

This is an open-source Filter for [Valence](https://valence.app), a Salesforce AppExchange app for orchestrating data integrations.

For additional information about Filters and how they work, see the [Valence documentation](https://docs.valence.app).

This particular Filter allows Valence users to configure a Link so that records being processed can be discarded (ignored). A Filter configuration is attached to one or more mappings, and then a list of values can be constructed. The Filter can be inclusive (only accept records with one of those values) or exclusive (reject any records with one of those values).

## In Action

Here's what it looks like to configure the Filter:

![Screenshot of the configuration screen for ignoring records](/images/configuration_ui.png)

And here's what it looks like when a record is blocked:

![Screenshot of the ignore reason on a Sync Event summary page](/images/ignore_message.png)

## Installing

To use this Filter you can either:
 
1. [Install an unlocked package version](https://github.com/valence-filters/ignore-records/releases)
2. Clone this repository

If you clone the repository and have Salesforce DX CLI set up, you can easily build a scratch org to test the filter by running `./scripts/create_dev_org`.