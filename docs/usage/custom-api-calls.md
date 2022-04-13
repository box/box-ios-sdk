Custom API Calls
================

There are a few situations where a user might want to make a custom API call — utilizing the SDK's authentication handling but creating the API request manually:
- When new endpoints and parameters have been introduced to the API, but are not yet supported directly by the SDK
- Beta endpoints that are not yet suitable for inclusion in the SDK
- Hitting URLs specified directly in the response of another API call, e.g. Representation Info and Download URLs

For this reason BoxClient exposes this functionality through a set of methods on the client mapping to HTTP verbs:

```swift
client.get(/*...*/)
client.post(/*...*/)
client.put(/*...*/)
client.delete(/*...*/)
client.options(/*...*/)
```

and additionally a HTTP GET method call for downloading:

```swift
client.download(/*...*/)
```

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Create URL](#create-url)
- [Deserialize Response Body](#deserialize-response-body)
- [API Calls](#api-calls)
    - [Custom GET](#custom-get)
    - [Custom POST](#custom-post)
    - [Custom PUT](#custom-put)
    - [Custom DELETE](#custom-delete)
    - [Custom OPTIONS](#custom-options)
    - [Download](#download)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


Create URL
----------
 When you want to execute custom API call you must specify an destination URL.
 You can create it by yourself:

``` swift
let fileId = "<YOUR_FILE_ID_HERE>"
let url = URL(string: "https://api.box.com/2.0/files/\(fileId)")!
```

or you can use SDK's predefined method for this
[`URL.boxAPIEndpoint(_ endpoint:configuration)`][create-box-api-endpoint]


``` swift
let fileId = "<YOUR_FILE_ID_HERE>"
let url = URL.boxAPIEndpoint("/2.0/files/\(fileId)", configuration: client.configuration)
```

The `boxAPIEndpoint` method requires from you to pass endpoint path and a configuration from current `BoxClient` instance. It internally fetches `apiBaseURL` and appends to it the endpoint path you passed. The `apiBaseURL` default value is `https://api.box.com` but you change this through 
[`sdk.updateConfiguration(apiBaseURL:uploadApiBaseURL:oauth2AuthorizeURL:maxRetryAttempts:tokenRefreshThreshold:consoleLogDestination:fileLogDestination:clientAnalyticsInfo:)`][update-configure] method.

[create-box-api-endpoint]: https://opensource.box.com/box-ios-sdk/Extensions/URL.html#/s:10Foundation3URLV6BoxSDKE14boxAPIEndpoint_13configurationACSS_AD0C16SDKConfigurationVtFZ

[update-configure]: https://opensource.box.com/box-ios-sdk/Classes/BoxSDK.html#/s:6BoxSDKAAC19updateConfiguration10apiBaseURL09uploadApifG0015oauth2AuthorizeG016maxRetryAttempts21tokenRefreshThreshold21consoleLogDestination04filesT019clientAnalyticsInfoy10Foundation0G0VSg_A2OSiSgSdSgAA07ConsolesT0CSgAA04FilesT0CSgAA06ClientwX0VSgtKF

Deserialize Response Body
-------------------------
All of exposed custom API methods return a [`BoxResponse`][box-response] object or an error if request fails.
The `BoxResponse` type has a `body` property of type `Data?`. If you want to deserialize its json content to specific custom type, you can use SDK's
[`ObjectDeserializer.deserialize(data:)`][deserialize-data] method to deserialize `Data?` to any type that conforms to `BoxModel`, or
[`ObjectDeserializer.deserialize(response:)`][deserialize-response] to deserialize `BoxResponse` to any type that conforms to `Decodable`.

```swift
let fileId = "<YOUR_FILE_ID_HERE>"

client.get(url: URL.boxAPIEndpoint("/2.0/files/\(fileId)", configuration: client.configuration)) { (result: Result<BoxResponse, BoxSDKError>) in
    let fileResult: Result<File, BoxSDKError> = result.flatMap { ObjectDeserializer.deserialize(data: $0.body)}
    
    switch fileResult {
    case .success(let file):
        print("File \(file.name) was created at \(file.createdAt)")
    case .failure(let error):
        print("Error retrieving file information")
    }
}
```

As you can see we are using `flatMap` operator on `Result` type to deserialize origin `body` to specific type which is `File` in our case. The [`ObjectDeserializer.deserialize(data: Data?)`][deserialize-data]  method returns `Result<ReturnType, BoxSDKError>` where `ReturnType` is inferenced as a `File`.

[deserialize-data]: https://opensource.box.com/box-ios-sdk/Enums/ObjectDeserializer.html#/s:6BoxSDK18ObjectDeserializerO11deserialize4datas6ResultOyxAA0A8SDKErrorCG10Foundation4DataVSg_tAA0A5ModelRzlFZ

[deserialize-response]: https://opensource.box.com/box-ios-sdk/Enums/ObjectDeserializer.html#/s:6BoxSDK18ObjectDeserializerO11deserialize8responses6ResultOyxAA0A8SDKErrorCGAA0A8ResponseV_tSeRzlFZ

[box-response]: https://opensource.box.com/box-ios-sdk/Structs/BoxResponse.html#/s:6BoxSDK0A8ResponseV7requestAA0A7RequestCvp

API Calls
----------
### Custom GET

To perform a custom HTTP GET method, call
[`client.get(url:httpHeaders:queryParameters:completion:)`][custom-client-get] 
with the destination `url` and with headers and query parameters if needed. As you can see in the `completion` parameter, the `Callback` closure returning a [`BoxResponse`][box-response] type. The `body` of the response you can find in `body` property which is of type `Data?`. If you want to deserialize it to a specific type, you can do so as in the example below:

```swift
let fileId = "<YOUR_FILE_ID_HERE>"

// Get information about a file.
client.get(url: URL.boxAPIEndpoint("/2.0/files/\(fileId)", configuration: client.configuration)) { (result: Result<BoxResponse, BoxSDKError>) in
    let fileResult: Result<File, BoxSDKError> = result.flatMap { ObjectDeserializer.deserialize(data: $0.body)}
    
    switch fileResult {
    case .success(let file):
        print("File \(file.name) was created at \(file.createdAt)")
    case .failure(let error):
        print("Error retrieving file information")
    }
}
```

As an alternative to to manually deserialize a response body you can use [`ResponseHandler.default(wrapping completion:)`][response-handler-default] method: 

```swift
let fileId = "<YOUR_FILE_ID_HERE>"

// Get information about a file.
client.get(
    url: URL.boxAPIEndpoint("/2.0/files/\(fileId)", configuration: client.configuration),
    completion: ResponseHandler.default(
        wrapping: { (result:  Result<File, BoxSDKError>) in
            switch result {
            case .success(let file):
                print("File \(file.name) was created at \(file.createdAt)")
            case .failure(let error):
                print("Error retrieving file information")
            }
        }
    )
)
```

This method will make sure that the response is successful (status code 2xx) and deserialize the response body into the appropriate type.

In this examples above we used existing SDKs type `File` but this can be either any your type that conforms either to `Decodable` either `BoxModel`.


[custom-client-get]: https://opensource.box.com/box-ios-sdk/Classes/BoxClient.html#/s:6BoxSDK0A6ClientC3get3url11httpHeaders15queryParameters10completiony10Foundation3URLV_SDyS2SGSDySSAA25QueryParameterConvertible_pSgGys6ResultOyAA0A8ResponseVAA0A8SDKErrorCGctF

[response-handler-default]: https://opensource.box.com/box-ios-sdk/Enums/ResponseHandler.html#/s:6BoxSDK15ResponseHandlerO7default8wrappingys6ResultOyAA0aC0VAA0A8SDKErrorCGcyAGyxAKGc_tAA0A5ModelRzlFZ

### Custom POST

To perform a custom HTTP POST method, call
[`client.post(url:httpHeaders:queryParameters:json:completion)`][custom-client-post] 
with the `url`, `json` body and with headers and query parameters if needed. As you can see in the `completion` parameter the `Callback` closure returning a [`BoxResponse`][box-response]  type. The `body` of the response you can find in `body` property which is of type `Data?`. If you want to deserialize it to a specific type, you can do so as in the examples below:

```swift
var body: [String: Any] = [:]
body["parent"] = ["id": "<YOUR_FOLDER_ID_HERE>"]
body["url"] = "https://example.com"
body["name"] = "example name"

// Creates a new web link with the specified url on the specified folder.
client.post(url: URL.boxAPIEndpoint("/2.0/web_links", configuration: client.configuration), json: body) { result in
    let webLinkResult: Result<WebLink, BoxSDKError> = result.flatMap { ObjectDeserializer.deserialize(data: $0.body) }
    
    switch webLinkResult {
    case .success(let webLink):
        print("WebLink \(webLink.name) was created")
    case .failure(let error):
        print("Error creating a webLink \(error)")
    }
}
```

or 

```swift
var body: [String: Any] = [:]
body["parent"] = ["id": "<YOUR_FOLDER_ID_HERE>"]
body["url"] = "https://example.com"
body["name"] = "example name"

// Creates a new web link with the specified url on the specified folder.
client.post(
    url: URL.boxAPIEndpoint("/2.0/web_links", configuration: client.configuration),
    json: body,
    completion: ResponseHandler.default(
        wrapping: { (result:  Result<WebLink, BoxSDKError>) in
            switch result {
            case .success(let webLink):
                print("WebLink \(webLink.name) was created")
            case .failure(let error):
                print("Error creating a webLink \(error)")
            }
        }
    )
)
```

In this examples we deserialized `body` as `WebLink` type but you can deserialize response's body to any of your types that conforms either to `Decodable` either `BoxModel`.

[custom-client-post]: https://opensource.box.com/box-ios-sdk/Classes/BoxClient.html#/s:6BoxSDK0A6ClientC4post3url11httpHeaders15queryParameters4json10completiony10Foundation3URLV_SDyS2SGSDySSAA25QueryParameterConvertible_pSgGypSgys6ResultOyAA0A8ResponseVAA0A8SDKErrorCGctF

### Custom PUT

To perform a custom HTTP PUT method, call
[`client.put(url:httpHeaders:queryParameters:json:completion:)`][custom-client-put] 
with the `url`, `json` body and with headers and query parameters if needed. As you can see in the `completion` parameter the `Callback` closure returning a [`BoxResponse`][box-response] type. The `body` of the response you can find in `body` property which is of type `Data?`. If you want to deserialize it to a specific type, you can do so as in the examples below:

```swift
let taskId = "<YOUR_TASK_ID_HERE>"
var body = [String: Any]()
body["message"] = "Please to this ASAP!"
body["action"] = "review"

// Updates a specific task.
client.put(url: URL.boxAPIEndpoint("/2.0/tasks/\(taskId)", configuration: client.configuration), json: body) { result in
    let taskResult: Result<Task, BoxSDKError> = result.flatMap { ObjectDeserializer.deserialize(data: $0.body) } 

    switch taskResult {
    case .success(let task):
        print("Task \(task.id) was updated")
    case .failure(let error):
        print("Error updating a task \(error)")
    }
}
```

or

```swift
let taskId = "<YOUR_TASK_ID_HERE>"
var body = [String: Any]()
body["message"] = "Please to this ASAP!"
body["action"] = "review"

// Updates a specific task.
client.put(
    url: URL.boxAPIEndpoint("/2.0/tasks/\(taskId)", configuration: client.configuration),
    json: body,
    completion: ResponseHandler.default(
        wrapping: { (result:  Result<Task, BoxSDKError>) in
            switch result {
            case .success(let task):
                print("Task \(task.id) was updated")
            case .failure(let error):
                print("Error updating a task \(error)")
            }
        }
    )
)
```

In this examples we deserialized `body` as `Task` type but we can deserialize it to any of your types that conforms either to `Decodable` either `BoxModel`.

[custom-client-put]: https://opensource.box.com/box-ios-sdk/Classes/BoxClient.html#/s:6BoxSDK0A6ClientC3put3url11httpHeaders15queryParameters4json10completiony10Foundation3URLV_SDyS2SGSDySSAA25QueryParameterConvertible_pSgGypSgys6ResultOyAA0A8ResponseVAA0A8SDKErrorCGctF

### Custom DELETE

To perform a custom HTTP DELETE method, call
[`client.delete(url:httpHeaders:queryParameters:completion:)`][custom-client-delete] 
with the `url` and with headers and query parameters if needed. As you can see in the `completion` parameter the `Callback` closure returning a [`BoxResponse`][box-response] type. The `body` of the response you can find in `body` property which is of type `Data?`. In most cases the `body` property on success will be just nil so to handle this you can do as follows:

```swift
let fileId = "<YOUR_FILE_ID_HERE>"

// Discards a file to the trash.
client.delete(url: URL.boxAPIEndpoint("/2.0/files/\(fileId)", configuration: client.configuration)) { result in 
    switch result {
    case .success:
        print("The file was deleted")
    case .failure(let error):
        print("Error deleting a file \(error)")
    }
}
```

[custom-client-delete]: https://opensource.box.com/box-ios-sdk/Classes/BoxClient.html#/s:6BoxSDK0A6ClientC6delete3url11httpHeaders15queryParameters10completiony10Foundation3URLV_SDyS2SGSDySSAA25QueryParameterConvertible_pSgGys6ResultOyAA0A8ResponseVAA0A8SDKErrorCGctF

### Custom OPTIONS

To perform a custom HTTP OPTIONS method, call
[`client.options(url:httpHeaders:queryParameters:json:completion:)`][custom-client-options] 
with the `url`, `json` body and with headers and query parameters if needed. As you can see in the `completion` parameter the `Callback` closure returning a [`BoxResponse`][box-response] type. The `body` of the response you can find in `body` property which is of type `Data?`.

```swift
var body: [String: Any] = ["parent": ["id": "<YOUR_FOLDER_ID_HERE>"]]
body["name"] = "<YOUR_FILE_NAME_HERE>"

// Verifies that new file will be accepted by Box before you send all the bytes over the wire.
client.options(url: URL.boxAPIEndpoint("/2.0/files/content", configuration: client.configuration)) { result in
    switch result {
    case .success:
        print("The file is verified successfully")
    case .failure(let error):
        print("Error verifying a file \(error)")
    }
}
```

This example will returns an empty response in case of the checks have been passed and user can proceed to make a upload call or an error.

[custom-client-options]: https://opensource.box.com/box-ios-sdk/Classes/BoxClient.html#/s:6BoxSDK0A6ClientC7options3url11httpHeaders15queryParameters4json10completionAA0A11NetworkTaskC10Foundation3URLV_SDyS2SGSDySSAA25QueryParameterConvertible_pSgGypSgys6ResultOyAA0A8ResponseVAA0A8SDKErrorCGctF

### Download

To perform a HTTP GET method call for downloading on an API, call
[`client.download(url:downloadDestinationURL:httpHeaders:queryParameters:progress:completion:)`][custom-download].
You must to specify an `url` of the API endpoint to call and `downloadDestinationURL` which specify the URL on disk where the data will be saved. The `completion` is callback which returns a [`BoxResponse`][box-response] object or an error if request fails. Headers and query parameters are optionals so add them if needed.

```swift
let fileId = "<YOUR_FILE_ID_HERE>"
let destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("<FILE_NAME_HERE>")

// Download a file to a specified folder.
client.download(
    url: URL.boxAPIEndpoint("/2.0/files/\(fileId)/content", configuration: client.configuration),
    downloadDestinationURL: destinationURL
) { result in
    switch result {
    case .success:
        print("The file was downloaded")
    case .failure(let error):
        print("Error downloaded a file \(error)")
    }
}
```

This example will returns an empty response in case of the success or an error.

[custom-download]: https://opensource.box.com/box-ios-sdk/Classes/BoxClient.html#/s:6BoxSDK0A6ClientC7options3url11httpHeaders15queryParameters4json10completionAA0A11NetworkTaskC10Foundation3URLV_SDyS2SGSDySSAA25QueryParameterConvertible_pSgGypSgys6ResultOyAA0A8ResponseVAA0A8SDKErrorCGctF
