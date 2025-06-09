Configuration
=============

The iOS SDK provides dedicated method, that helps you to customize SDK configuration. All you need is to call
[`sdk.updateConfiguration(apiBaseURL:uploadApiBaseURL:oauth2AuthorizeURL:maxRetryAttempts:tokenRefreshThreshold:consoleLogDestination:fileLogDestination:clientAnalyticsInfo:)`][update-configure] method on `BoxSDK` instance with correct parameters, right after creating a `BoxSDK` instance, but before creating a `BoxClient`.

[update-configure]: https://opensource.box.com/box-ios-sdk/Classes/BoxSDK.html#/s:6BoxSDKAAC19updateConfiguration10apiBaseURL09uploadApifG0015oauth2AuthorizeG016maxRetryAttempts21tokenRefreshThreshold21consoleLogDestination04filesT019clientAnalyticsInfoy10Foundation0G0VSg_A2OSiSgSdSgAA07ConsolesT0CSgAA04FilesT0CSgAA06ClientwX0VSgtKF


  - [URLs configuration](#urls-configuration)
    - [Api Base URL](#api-base-url)
    - [Upload Api Base URL](#upload-api-base-url)
    - [OAuth Authorize URL](#oauth-authorize-url)
  - [Max retry attempts](#max-retry-attempts)
  - [Token Refresh Threshold](#token-refresh-threshold)
  - [Logging](#logging)
    - [Console Logging](#console-logging)
    - [File Logging](#file-logging)
  - [Client Analytics Info](#client-analytics-info)
  

URLs configuration
------------------

The `sdk.updateConfiguration()` method allows you to change base URLs from defaults to the ones you will specify. Just call this method on the `BoxSDK` instance with any of these parameters:


```swift
do {
    try sdk.updateConfiguration(
        apiBaseURL: URL(string: "https://my-company.com"),
        uploadApiBaseURL: URL(string: "https://my-company.com/upload"),
        oauth2AuthorizeURL: URL(string: "https://my-company.com/oauth2")
    )
} catch {
    print("An error occurred \(error)")
}
```

The `updateConfiguration()` will throw an exception if any of passed URLs will be invalid.

### Api Base URL

The `apiBaseURL` sets URL to which all API calls will be directed.
Final URL that is used to access Box is built using `apiBaseURL` and the API Version (`2.0`). For example, by default the `apiBaseURL`
is set to `https://api.box.com`, so after appending the currently supported API version the URL is : `https://api.box.com/2.0`.

### Upload Api Base URL

The `uploadApiBaseURL` is used to configure the base URL used when uploading files.
Final URL used to access Box is built using `uploadApiBaseURL`, the `/api/` path and API Version (`2.0`). For example, by default the `uploadApiBaseURL`
is set to `https://upload.box.com`, so after appending `/api/` path and the currently supported API version the URL is : `https://upload.box.com/api/2.0`.

### OAuth Authorize URL

The `oauth2AuthorizeURL` is an URL for the OAuth2 authorization page, where users are redirected to enter their credentials to obtain OAuth2 authorization tokens. By default is set to `https://account.box.com/api/oauth2/authorize`. 


Max retry attempts
------------------

The default maximum number of retries in case of failed API call is `5`. To change this please call `sdk.updateConfiguration()` method with `maxRetryAttempts` parameter and your new value e.g. `10`: 

```swift
do {
    try sdk.updateConfiguration(
        maxRetryAttempts: 10
    )
} catch {
    print("An error occurred \(error)")
}
```

Token Refresh Threshold
-----------------------

You can specify how many seconds before the token expires, it should be refreshed. By default it is set to `60` seconds. To change this value, please call `sdk.updateConfiguration()` method with `tokenRefreshThreshold` parameter and your new value, e.g. `120`:

```swift
do {
    try sdk.updateConfiguration(
        tokenRefreshThreshold: 120
    )
} catch {
    print("An error occurred \(error)")
}
```

Logging
-----------------------

### Console Logging

There could be a situation when the default console Box SDK logging is not sufficient for your needs. You can then create your own class that inherits form [`ConsoleLogDestination`][console-log-destination] class and you can overwrite `write` method for you needs (as this is a method that writes logs into the console). If you named this class e.g. `CustomConsoleLogDestination` then call:

```swift
do {
    try sdk.updateConfiguration(
        consoleLogDestination: CustomConsoleLogDestination()
    )
} catch {
    print("An error occurred \(error)")
}
```

[console-log-destination]: https://opensource.box.com/box-ios-sdk/Classes/ConsoleLogDestination.html

### File Logging

By default, logging to a file is disabled in the Box SDK. To turn it on, you just need to pass the `fileLogDestination` parameter to the new instance of [`FileLogDestination`][file-log-destination]. To create a new instance of `FileLogDestination`, you need to pass the `fileURL` parameter, which is the file path URL to write the logs to.

```swift
let fileLoggerURL = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first!.appendingPathComponent("box_sdk_log.txt")

do {
    try sdk.updateConfiguration(
        fileLogDestination: FileLogDestination(fileURL: fileLoggerURL)
    )
} catch {
    print("An error occurred \(error)")
}
```

[file-log-destination]: https://opensource.box.com/box-ios-sdk/Classes/FileLogDestination.html


Client Analytics Info
-----------------------

If for some reasons you want to track your application usage on server, there is a way for that. 
You just need to create an instance of [`ClientAnalyticsInfo`][client-analytics-info] struct with `appName` and `appVersion` parameters related to your app and pass it to `sdk.updateConfiguration()`
method. Those values will be added to `X-Box-UA` request header after `agent` and `env` values.
Take a look at the following code:

```swift
let analyticsInfo = ClientAnalyticsInfo(appName: "MyCustomApp", appVersion: "1.2.0")

do {
    try sdk.updateConfiguration(clientAnalyticsInfo: analyticsInfo)
} catch {
    print("An error occurred \(error)")
}
```

After this change, the `client=MyCustomApp/1.2.0` will be appended to the `X-Box-UA` request header value.
If you run this code on `iPhone 11 Pro Max` and using SDK version `5.2.0` the final value for `X-Box-UA` header will be
 `agent=box-swift-sdk/5.2.0; env=iPhone Simulator/15.2; client=MyCustomApp/1.2.0`.

[client-analytics-info]: https://opensource.box.com/box-ios-sdk/Structs/ClientAnalyticsInfo.html
