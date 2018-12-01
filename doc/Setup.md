App Setup
=========

Create Your Application
-----------------------
Log in to the [Box Developers page](https://developers.box.com/) and create your application.

For apps that expect a user to already have a Box account, select 'Partner Integration'.  For apps that are going to leverage Box Platform and App Users select 'Custom App'.

Configure Your Partner Integration App
--------------------------
Read the documentation for working with [Partner Integrations](https://developer.box.com/docs/partner-integrations).

Then, in your App configuration page, find your 'client_id' and 'client_secret' under 'OAuth2 Parameters'. These values are needed for initializing the SDK in your app.

Find the 'redirect_uri' field, also in the 'OAuth2 Parameters' section. Make sure it is populated with the expected format: boxsdk-YOUR_CLIENT_ID_HERE://boxsdkoauth2redirect. This is needed for authentication to work in your app. The SDK expects this pattern.
Make sure you replace the 'YOUR_CLIENT_ID_HERE' string with your client ID value from the 'client_id' field. The dash ('-') remains.

Configure Your Custom App (Box Platform)
--------------------------
Read the documentation for working with [Custom Applications](https://developer.box.com/docs/custom-applications).

Then, see the documentation for configuring your iOS app to work with [Box Platform](https://github.com/box/box-ios-sdk/tree/master/doc).