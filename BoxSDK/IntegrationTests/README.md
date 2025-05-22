# Integration Tests

## Running integration tests locally

### Create Custom Application

To run integration tests locally you will need a `Custom App` created at https://cloud.app.box.com/developers/console 
with `Server Authentication (Client Credentials Grant)` selected as authentication method.
Once created you can edit properties of the application. 

In section `App Access Level` select `App + Enterprise Access`. 

You can enable all `Application Scopes`.

In section `Advanced Features` enable `Make API calls using the as-user header`.

Now select `Authorization` and submit application to be reviewed by account admin.

### Completing the configuration file

Next, you will need to fill the `Configuration.json` file which is located under the following path `./IntegrationTests/Resources/Configuration.json` and look like this:

```json
{
    "ccg": {
        "clientId": "",
        "clientSecret": "",
        "enterpriseId": "",
        "userId": ""
    },
    "data": {
        "collaboratorId": ""
    }
}
```

 - `clientId` - you can find this in `Configuration` tab, in `Client ID` field
 - `clientSecret` - you can find this in `Configuration` tab, after tapped to `Fetch Client Secret` button
 - `enterpriseId` - you can find this in `General Settings` tab in field `Enterprise ID`
 - `userId` - you can find this in `General Settings` tab in field `User ID`
 - `collaboratorId` - please enter the ID of your designated collaborator here for testing purposes only. It is not required, however if you skip this field, then a few test will fail.

You should pass either `enterpriseId` if you want to use Service Account account in your tests or `userId` if you want making calls as an App User or Managed User. In case when both these parameters will be filled, `enterpriseId` will be used. For more information about CCG authentication, please read [this document](../docs/usage/authentication.md#client-credentials-grant).


### Running Tests

There are two ways to run tests:

#### 1) From XCode
   
First, open the `BoxSDK.xcworkspace` file and select the `BoxSDKIntegrationTests-iOS` scheme (`Product -> Scheme -> BoxSDKIntegrationTests-iOS`). Then run tests by selecting `Product -> Tests`.

Make sure you have selected the target simulator before running these tests.

#### 2) From command line

Before run tests from command line, you should select the target simulator to run these tests on.
In my case, I have `XCode 13.2.1` installed with `iOS SDK 15.2` and I want to run tests on iPhone 11 Simulator. 
So my destination target will be `platform=iOS Simulator,OS=15.2,name=iPhone 11`.

```bash
xcodebuild -workspace BoxSDK.xcworkspace \
-scheme BoxSDKIntegrationTests-iOS \
-destination "platform=iOS Simulator,OS=15.2,name=iPhone 11" \
-configuration Debug ENABLE_TESTABILITY=YES test
```

