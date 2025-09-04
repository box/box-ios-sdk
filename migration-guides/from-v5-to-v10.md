# Migration guide from v5 to v10 of `Box iOS SDK`

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Introduction](#introduction)
- [Installation](#installation)
  - [Swift Package Manager](#swift-package-manager)
  - [Carthage](#carthage)
- [CocoaPods](#cocoapods)
- [Highlighting the Key Differences](#highlighting-the-key-differences)
  - [Different import statement](#different-import-statement)
  - [Async await support](#async-await-support)
  - [Consistent method signature](#consistent-method-signature)
- [Diving into Authentication](#diving-into-authentication)
  - [Developer Token](#developer-token)
  - [Client Credentials Grant](#client-credentials-grant)
    - [Service Account Token Acquisition](#service-account-token-acquisition)
    - [User Token Acquisition](#user-token-acquisition)
    - [Smooth Switching between Service Account and User](#smooth-switching-between-service-account-and-user)
  - [OAuth 2.0 Authentication](#oauth-20-authentication)
    - [Built-in flow](#built-in-flow)
    - [Manual flow](#manual-flow)
      - [Get Authorization URL](#get-authorization-url)
      - [Authentication](#authentication)
  - [Customizable Token Storage](#customizable-token-storage)
  - [Downscoping Tokens](#downscoping-tokens)
  - [Revoking Tokens](#revoking-tokens)
- [Configuration](#configuration)
  - [As-User header](#as-user-header)
  - [Custom Base URLs](#custom-base-urls)
- [Convenience methods](#convenience-methods)
  - [Chunked upload of big files](#chunked-upload-of-big-files)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Introduction

The v10 release of `Box iOS SDK` library helps developers to conveniently integrate with Box API.
In the contrary to the previous versions (v5 or lower), it is not manually maintained, but auto-generated
based on Open API Specification. This means you can leverage the most up-to-date Box API features in your
applications without delay. We introduced this major version bump to reflect the significant codebase changes
and to align with other Box SDKs, which will also adopt generated code starting from their v10 releases.
More information and benefits of using the new can be found in the
[README](https://github.com/box/box-ios-sdk/blob/sdk-gen/README.md) file.

## Installation

Soon we are going to introduce v6 version of Box iOS SDK that will combine `BoxSDK` from v5
and the `BoxSdkGen` from v10 of the SDK, so that code from both versions could be used in the same project.
If you would like to use a feature available only in the new SDK, you won't need to necessarily migrate all your code
to use generated SDK at once. You will be able to use a new feature from the `BoxSdkGen` project,
while keeping the rest of your code unchanged. Note that it may be required to use aliases for some of the imported types
to avoid conflicts between two libraries. However, we recommend to fully migrate to the v10 of the SDK eventually.

### Swift Package Manager

[The Swift Package Manager](https://www.swift.org/package-manager/) is a tool for managing the distribution of Swift code.
It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

To add a dependency to your Xcode project, click on Xcode project file on `Packages Dependencies` and click on the plus icon to add a package.
Then enter the following repository url https://github.com/box/box-ios-sdk.git and select the version by choosing `Up to Next Major Version` and entering `10.0.0` as the starting version.

Alternatively you can add a dependency to the dependencies value of your `Package.swift`:

```swift
dependencies: [
  .package(url: "https://github.com/box/box-ios-sdk.git", .upToNextMajor(from: "10.0.0"))
]
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager which builds your dependencies and provides you with binary frameworks.

To add a dependency to the v10 version of `Box iOS SDK`, you need to add the following line to your `Cartfile` :

```shell
git "https://github.com/box/box-ios-sdk.git" >= 10.0.0
```

Then run:

```shell
carthage bootstrap --use-xcframeworks
```

And finally drag the built `xcframework` from Carthage/Build into your project.

## CocoaPods

CocoaPods is a dependency manager for Swift and Objective-C Cocoa projects.
To start using `BoxSDK` with CocoaPods, you need to add `BoxSDK` dependency to your `Podfile`:

```shell
pod 'BoxSDK', '>= 10.0.0'
```

Then run the following command in your project directory:

```shell
$ pod install
```

## Highlighting the Key Differences

### Different import statement

**Old (`v5`):**

In the v5 version of `Box iOS SDK`, you needed to import the `BoxSDK` module to access the SDK's functionality:

```swift
import BoxSDK
```

**New (`v10`):**

In the v10 version of `Box iOS SDK`, since the code is auto-generated, and to avoid confusion with the previous version of the SDK, you need to import the `BoxSdkGen` module instead:

```swift
import BoxSdkGen
```

Having different import statements, which actually import different modules, will allow you to use both versions of the SDK `BoxSDK` and `BoxSdkGen` in the upcoming v6 version of the SDK.

### Async await support

One of the main changes between the v10 and v5 version of the SDK is the addition of async/await support for all API methods.

**Old (`v5`):**

In the v5 version of `Box iOS SDK`, API interactions allowed for passing `callback` as the last argument:

```swift
import BoxSDK

client.users.getCurrent(fields: ["name", "login"]) { result in
    guard case let .success(user) = result else {
        print("Error getting user information")
        return
    }

    // now you can safely access to user object
    print("Authenticated as \(user.name), with login \(user.login)")
}
```

**New (`v10`):**

The v10 version of `Box iOS SDK` ensures consistent use of async/await throughout the entire SDK, making asynchronous code more readable and easier to understand compared to nested callback functions.

Let's compare an example of a similar method as above, but using added support for async/await:

```swift
import BoxSdkGen

let user = try await client.users.getUserMe()
```

### Consistent method signature

To facilitate easier work with the new SDK, we have changed the API method signatures to be consistent and unified.

**Old (`v5`):**

In the v5 version of `Box iOS SDK`, API methods had numerous parameters, requiring access to all necessary data when calling a particular method.

```swift
import BoxSDK

public func update(
    fileId: String,
    name: String? = nil,
    description: String? = nil,
    parentId: String? = nil,
    sharedLink: NullableParameter<SharedLinkData>? = nil,
    tags: [String]? = nil,
    collections: [String]? = nil,
    lock: NullableParameter<LockData>? = nil,
    dispositionAt: Date? = nil,
    ifMatch: String? = nil,
    fields: [String]? = nil,
    completion: @escaping Callback<File>
)
```

**New (`v10`):**

In the v10 version of `Box iOS SDK`, we have adopted an approach of aggregating parameters into types based on their nature (path, body, query, headers).
This can be seen in the example corresponding to the above:

```swift
import BoxSdkGen

public func updateFileById(
    fileId: String,
    requestBody: UpdateFileByIdRequestBodyArg = UpdateFileByIdRequestBodyArg(),
    queryParams: UpdateFileByIdQueryParamsArg = UpdateFileByIdQueryParamsArg(),
    headers: UpdateFileByIdHeadersArg = UpdateFileByIdHeadersArg()
) async throws -> FileFull
```

According to the convention, if an API endpoint requires a parameter placed in the URL path, it will appear at the beginning of our method, such as `fileId` in this case. When a request allows for a body, as in `POST` or `PUT`, the method includes a parameter named `requestBody`. Following that, the method signature may include the `queryParams` parameter, followed by `headers`.

The types of parameters `requestBody`, `queryParams`, and `headers` are specific to each endpoint and, in their definition, encompass all fields allowed by the API.

It's worth noting here that when all fields of a particular type are optional, the entire parameter becomes optional as well. This allows us to pass only the parameters we actually want to provide when calling a given method, without the risk of not providing a sufficient number of parameters.

## Diving into Authentication

Authentication is a crucial aspect of any SDK. Let's delve into the authentication methods supported by both SDKs and understand the enhancements in the new version:

### Developer Token

The Developer Token remains a straightforward method for authentication:

**Old (`v5`):**

```swift
import BoxSDK

let client = BoxSDK.getClient(token: "YOUR_DEVELOPER_TOKEN")
```

**New (`v10`):**

```swift
import BoxSdkGen

let auth = BoxDeveloperTokenAuth(token: "YOUR_DEVELOPER_TOKEN")
let client = BoxClient(auth: auth)
```

### Client Credentials Grant

The Client Credentials Grant method is a popular choice for many developers. Let's see how it's been changed:

#### Service Account Token Acquisition

**Old (`v5`):**

```swift
import BoxSDK

let sdk = BoxSDK(clientId: "YOUR_CLIENT_ID", clientSecret: "YOUR_CLIENT_SECRET")
let client = try await sdk.getCCGClientForAccountService(enterpriseId: "YOUR_ENTERPRISE_ID")
```

**New (`v10`):**

```swift
import BoxSdkGen

let config = CCGConfig(
  clientId: "YOUR_CLIENT_ID",
  clientSecret: "YOUR_CLIENT_SECRET",
  enterpriseId: "YOUR_ENTERPRISE_ID"
)
let auth = BoxCCGAuth(config: config)
let client = BoxClient(auth: auth)
```

#### User Token Acquisition

**Old (`v5`):**

```swift
import BoxSDK

let sdk = BoxSDK(clientId: "YOUR_CLIENT_SECRET", clientSecret: "YOUR_CLIENT_SECRET")
let client = try await sdk.getCCGClientForUser(userId: "YOUR_USER_ID")
```

**New (`v10`):**

```swift
import BoxSdkGen

let config = CCGConfig(
  clientId: "YOUR_CLIENT_ID",
  clientSecret: "YOUR_CLIENT_SECRET",
  userId: "YOUR_USER_ID"
)
let auth = BoxCCGAuth(config);
let client = BoxClient(auth: auth)
```

#### Smooth Switching between Service Account and User

Transitioning between account types is now more intuitive:

**New (`v10`):**

```swift
import BoxSdkGen

auth.asEnterprise(enterpriseId: "YOUR_ENTERPRISE_ID")
```

### OAuth 2.0 Authentication

Using an auth code is the most common way of authenticating with the Box API for existing Box users, to integrate with their accounts.

#### Built-in flow

Both versions of the SDK, the v5 and the v10, provides a built-in flow for opening a secure web view, into which the user enters their Box login credentials.
However, let's examine the differences between them.

**Old (`v5`):**

```swift
import BoxSDK

let sdk = BoxSDK(clientId: "YOUR_CLIENT_ID", clientSecret: "YOUR_CLIENT_SECRET", callbackURL: "YOUR_REDIRECT_URL")
let client = try await sdk.getOAuth2Client(tokenStore: KeychainTokenStore())
```

**New (`v10`):**

```swift
import BoxSdkGen

let config = OAuthConfig(clientId: "YOUR_CLIENT_ID", clientSecret: "YOUR_CLIENT_SECRET", tokenStorage: KeychainTokenStorage())
let oauth = BoxOAuth(config: config)
try await oauth.runLoginFlow(options: AuthorizeUrlParams(redirectUri: "YOUR_REDIRECT_URL"), context: self)

let client = BoxClient(auth: oauth)
```

#### Manual flow

As an alternative to the built-in flow, where everything is done automatically, you can opt for the manual one, which has been added only to the v10 of the `Box iOS SDK`.

##### Get Authorization URL

First, you need to create the authorization URL based on the provided client data and redirect the user to this URL.

```swift
import BoxSdkGen

let config = OAuthConfig(clientId: "YOUR_CLIENT_ID", clientSecret: "YOUR_CLIENT_SECRET")
let authorizationUrl = auth.getAuthorizeUrl()
```

##### Authentication

After a user logs in and grants your application access to their Box account, they will be redirected to your application's `redirectUri` which will contain an authorization code.
This code can then be used along with your client ID and client secret to establish an API connection.
You need to provide the authorization code to the SDK to obtain an access token, then you can use the SDK as usual.

```swift
import BoxSdkGen

auth.getTokensAuthorizationCodeGrant(authorizationCode: "YOUR_AUTHORIZATION_CODE")
let client = BoxClient(auth: oauth)
```

### Customizable Token Storage

Both versions of the SDK, the v5 and the v10, allows for the creation of a custom Token Storage, which can be provided when creating an instance of the `AuthConfig` class.

However, let's examine the differences in their implementation.

**Old (`v5`):**

In the v5 version of `Box iOS SDK`, the custom token storage must conform to the `TokenStore` protocol, with the API of the methods being callback-based:

```swift
import BoxSDK

public class MyCustomTokenStore: TokenStore {

    public func read(completion: @escaping (Result<TokenInfo, Error>) -> Void) {
        // YOUR IMPLEMENTATION GOES HERE
    }

    public func write(tokenInfo: TokenInfo, completion: @escaping (Result<Void, Error>) -> Void) {
        // YOUR IMPLEMENTATION GOES HERE
    }

    public func clear(completion: @escaping (Result<Void, Error>) -> Void) {
        // YOUR IMPLEMENTATION GOES HERE
    }
}
```

**New (`v10`):**

In the v10 version of `Box iOS SDK`, a custom token storage must conform to the `TokenStore`, where the API is async/await:

```swift
import BoxSdkGen

public class MyCustomTokenStore: TokenStorage {

    public func store(token: AccessToken) async throws {
        // YOUR IMPLEMENTATION GOES HERE
    }
    public func get() async throws -> AccessToken? {
        // YOUR IMPLEMENTATION GOES HERE
    }

    public func clear() async throws {
        // YOUR IMPLEMENTATION GOES HERE
    }
}

let tokenStorage = MyCustomTokenStore();
let config = OAuthConfig(clientId: "YOUR_CLIENT_ID", clientSecret: "YOUR_CLIENT_SECRET", tokenStorage: tokenStorage);
```

### Downscoping Tokens

Downscoping is a way to exchange an existing Access Token for a new one that is more restricted.

Let's see how it's been changed:

**Old (`v5`):**

```swift
import BoxSDK

client.exchangeToken(scope: ["item_preview"], resource: "https://api.box.com/2.0/files/123456789") { result in
    guard case let .success(tokenInfo) = result else {
        print("Error exchanging tokens")
        return
    }

    // tokenInfo contains the downscoped accessToken
    print("Got new access token: \(tokenInfo.accessToken)")
}
```

**New (`v10`):**

In the v10 version of `Box iOS SDK`, downscoping is available only for OAuth and CCG authentication.
Therefore, to downscope a token, we need to call the `downscopeToken` method directly on an instance of the `BoxOAuth` or `BoxCCGAuth` class, and not on the client instance as was the case in the old SDK.

```swift
import BoxSdkGen

let accessToken: AccessToken = try await auth.downscopeToken(scopes: ["item_preview"], resource: "https://api.box.com/2.0/files/123456789")
```

### Revoking Tokens

**Old (`v5`):**

```swift
import BoxSDK

client.destroy() { result in
    guard case .success = result else {
        print("Tokens could not be revoked!")
    }

    print("Tokens were successfully revoked")
}
```

**New (`v10`):**

Similarly to downscoping, revoke is available only for OAuth and CCG authentication.

```swift
import BoxSdkGen

try await auth.revokeToken()
```

## Configuration

### As-User header

The As-User header is used by enterprise admins to make API calls on behalf of their enterprise's users.
This requires the API request to pass an `As-User: USER-ID` header. The following examples assume that the client has
been instantiated with an access token with appropriate privileges to make As-User calls.

**Old (`v5`)**
In v5 you could call `.asUser(withId: String) -> BoxClient` method to create a new client to impersonate the provided user.

```swift
import BoxSDK

let asUserClient = client.asUser(withId: "<USER_ID>")
```

**New (`v10`)**

In v10 the method was renamed to `.withAsUserHeader(userId: String) -> BoxClient`
and returns a new instance of `BoxClient` class with the As-User header appended to all API calls made by the client.
The method accepts only user id as a parameter.

```swift
import BoxSdkGen

let userClient: BoxClient = client.withAsUserHeader(userId: "<USER_ID>")
```

Additionally `BoxClient` offers a `withExtraHeaders(extraHeaders: [String: String] = [:]) -> BoxClient`
method, which allows you to specify the custom set of headers, which will be included in every API call made by client.
Calling the `client.withExtraHeaders(extraHeaders: extraHeaders)` method creates a new client, leaving the original client unmodified.

```swift
import BoxSdkGen

let clientWithHeaders: BoxClient = client.withExtraHeaders(extraHeaders: ["my-custom-header": "my-custom-value"])
```

### Custom Base URLs

**Old (`v5`)**

In the v5 version of the SDK, you could specify the custom base URLs, which will be used for API calls made by setting
the new values on the BoxSDK instance by calling the `updateConfiguration` method.

```swift
import BoxSDK

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

**New (`v10`)**

In the new v10 version of the SDK this functionality has been implemented as part of the `BoxClient` class.
By calling the `client.withCustomBaseUrls()` method, you can specify the custom base URLs that will be used for API
calls made by client. Following the immutability pattern, this call creates a new client, leaving the original client unmodified.

```swift
import BoxSdkGen

let newClient = client.withCustomBaseUrls(baseUrls: BaseUrls(
  baseUrl: "https://api.box.com",
  uploadUrl: "https://upload.box.com/api",
  oauth2Url: "https://account.box.com/api/oauth2"
)
```

## Convenience methods

### Chunked upload of big files

For large files or in cases where the network connection is less reliable, you may want to upload the file in parts.
This allows a single part to fail without aborting the entire upload, and failed parts are being retried automatically.

**Old (`v5`):**

In the v5 version of the SDK, you should create a file upload session using the `createUploadSession` method,
then upload parts of the file using the `uploadPart` method, and finally commit the upload session using the `commitUpload` method.
All the process of uploading was manual and required multiple calls to the SDK methods.

**New (`v10`):**

In the v10 version of the SDK, all that logic is encapsulated in a single method call, so you don't have to worry about the details of the upload process.
You just need to call the `client.chunkedUploads.uploadBigFile` method, and pass input stream of the file, its name, size, and the ID of the parent folder where the file will be uploaded.

```swift
import BoxSdkGen

guard let fileByteStream = InputStream(url: URL(string: "<URL_TO_YOUR_FILE>")!) else {
    fatalError("Could not read a file")
}
let fileName = "<NAME_OF_YOUR_FILE>";
let parentFolderId = "<FOLDER_ID_WHERE_FILE_WILL_BE_UPLOADED>";
let fileSize: Int64 = <SIZE_OF_YOUR_FILE_IN_BYTES>;

try await client.chunkedUploads.uploadBigFile(
   file: fileByteStream,
   fileName: fileName,
   fileSize: Int64(fileSize),
   parentFolderId: parentFolderId
)
```
