App Setup
=========

Create Your Application
-----------------------
Log in to the [Box Developers page](https://developers.box.com/) and create your application.

Select 'Box Content' since the Box Content SDK for iOS uses the Content API.

Configure Your Application
--------------------------
In your App configuration page, find your 'client_id' and 'client_secret' under 'OAuth2 Parameters'. These values are needed for initializing the SDK in your app.

Find the 'redirect_uri' field, also in the 'OAuth2 Parameters' section. Make sure it is populated with the expected format: boxsdk-YOUR_CLIENT_ID_HERE://boxsdkoauth2redirect. This is needed for authentication to work in your app. The SDK expects this pattern.
Make sure you replace the 'YOUR_CLIENT_ID_HERE' string with your client ID value from the 'client_id' field. The dash ('-') remains.