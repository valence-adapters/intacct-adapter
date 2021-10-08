# Valence Intacct Adapter

This is a custom extension for <a href="https://valence.app">Valence</a>, a <a href="https://appexchange.salesforce.com/appxListingDetail?listingId=a0N3A00000EORP4UAP">managed package on the Salesforce AppExchange</a> that provides integration middleware natively in a Salesforce org.

To learn more about developing extensions for the Valence platform, check out <a href="https://docs.valence.app">the Valence documentation</a>.

This particular Adapter allows Valence users to move data bidirectionally with their instance of [Sage Intacct](https://www.sageintacct.com/).


## Installing

Click this button to install the extension into your Salesforce org.

<a href="https://githubsfdeploy.herokuapp.com?owner=valence-adapters&repo=intacct-adapter&ref=main">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

## Setting Up Intacct Authentication

After installing, you will need to configure the Adapter with the appropriate credentials from your Intacct environment.

You will the following pieces of information:
1. Intacct Company Id
2. Web Services credentials (a "sender id" and a "sender password")
3. Company credentials (a "user id" and "user password")

There is also some setup on the Intacct side to allow API access.

https://developer.intacct.com/web-services/#authentication
https://developer.intacct.com/support/faq/#why-am-i-getting-an-error-about-an-invalid-web-services-authorization

The Company Id and Web Services credentials need to be set on the Intacct Adapter custom metadata record in Valence. Search for "custom metadata" in the Setup menu and go to the Valence Adapters.

Replace the placeholder values on both the source and target configurations with your real values.

![Screenshot of the Adapter configuration screen](/images/adapter_configuration.png)

Next we'll set up a Salesforce [Named Credential](https://help.salesforce.com/s/articleView?id=sf.named_credentials_about.htm&type=5) to hold our URL and Company credentials.

Search for "named credential" in the Setup menu, then create a new one (use whatever name + label make sense to you).

The URL for the Intacct API is "https://api.intacct.com/ia/xml/xmlgw.phtml".

For Identity Type select "Named Principle" and for Authentication Protocol select "Password Authentication". Put in your Company credentials.

***Important!***: Be sure to check the box for "Allow Merge Fields in HTTP Body", and uncheck "Generate Authorization Header".

When you're done, it should look like this screenshot:

![Screenshot of the Named Credential configuration screen](/images/named_credential_configuration.png)