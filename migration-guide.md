# Migration Guide: From `Box iOS SDK` to `Box Swift SDK`

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Introduction](#introduction)
- [Installation](#installation)
  - [Swift Package Manager](#swift-package-manager)
  - [Carthage](#carthage)
- [Highlighting the Key Differences](#highlighting-the-key-differences)
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

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Introduction

Welcome to the `Box Swift SDK`, the pinnacle of Box's SDK evolution tailored for developers eager to integrate with the Box API using Swift. This next-generation toolkit is meticulously crafted with contemporary development practices, ensuring an unparalleled, seamless experience.

While the `Box iOS SDK` served its purpose well, the `Box Swift SDK` elevates the experience to new heights. One of its standout features is its auto-generation directly from the Open API Specification. This guarantees that developers are always equipped with the latest Box API features, eliminating any lag or discrepancies.

This guide is your compass, offering insights and directions for a smooth migration from the legacy `Box iOS SDK` to the state-of-the-art `Box Swift SDK`. As we journey through, we'll spotlight the key differences, enhanced functionalities, and the myriad benefits that await.

For those who wish to delve deeper into the intricacies and advantages of the new SDK, the [official README](https://github.com/box/box-swift-sdk-gen/blob/main/README.md) is a treasure trove of information.

## Installation

### Swift Package Manager

[The Swift Package Manager](https://www.swift.org/package-manager/) is a tool for managing the distribution of Swift code.
It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

To add a dependency to your Xcode project, click on Xcode project file on `Packages Dependencies` and click on the plus icon to add a package. Then enter the following repository url https://github.com/box/box-swift-sdk-gen.git and click next.

Alternatively you can add a dependency to the dependencies value of your `Package.swift`:

```
dependencies: [
    .package(url: "https://github.com/box/box-swift-sdk-gen.git", from: "0.1.0")
]
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager which builds your dependencies and provides you with binary frameworks.

To add a dependency to `Box Swift SDK`, you need to add the following line to your `Cartfile` :

```shell
git "https://github.com/box/box-swift-sdk-gen.git"
```

Then run:

```shell
carthage bootstrap --use-xcframeworks
```

And finally drag the built `xcframework` from Carthage/Build into your project.

## Highlighting the Key Differences

### Async await support

One of the main changes between the new and old SDK is the addition of async/await support for all API methods.

**Legacy (`Box iOS SDK`):**

In the older SDK, API interactions allowed for passing `callback` as the last argument:

```swift
client.users.getCurrent(fields: ["name", "login"]) { result in
    guard case let .success(user) = result else {
        print("Error getting user information")
        return
    }

    // now you can safely access to user object
    print("Authenticated as \(user.name), with login \(user.login)")
}
```

**Modern (`Box Swift SDK`):**

The new SDK ensures consistent use of async/await throughout the entire SDK, making asynchronous code more readable and easier to understand compared to nested callback functions.

Let's compare an example of a similar method as above, but using added support for async/await:

```swift
let user = try await client.users.getUserMe()
```

### Consistent method signature

To facilitate easier work with the new SDK, we have changed the API method signatures to be consistent and unified.

**Legacy (`Box iOS SDK`):**

In the old SDK, API methods had numerous parameters, requiring access to all necessary data when calling a particular method.

```swift
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

**Modern (`Box Swift SDK`):**

In the new SDK, we have adopted an approach of aggregating parameters into types based on their nature (path, body, query, headers).
This can be seen in the example corresponding to the above:

```swift
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

**Legacy (`Box iOS SDK`):**

```swift
let client = BoxSDK.getClient(token: "YOUR_DEVELOPER_TOKEN")
```

**Modern (`Box Swift SDK`):**

```swift
let auth = BoxDeveloperTokenAuth(token: "YOUR_DEVELOPER_TOKEN")
let client = BoxClient(auth: auth)
```

### Client Credentials Grant

The Client Credentials Grant method is a popular choice for many developers. Let's see how it's been changed:

#### Service Account Token Acquisition

**Legacy (`Box iOS SDK`):**

```swift
let sdk = BoxSDK(clientId: "YOUR_CLIENT_ID", clientSecret: "YOUR_CLIENT_SECRET")
let client = try await sdk.getCCGClientForAccountService(enterpriseId: "YOUR_ENTERPRISE_ID")
```

**Modern (`Box Swift SDK`):**

```swift
let config = CCGConfig(
  clientId: "YOUR_CLIENT_ID",
  clientSecret: "YOUR_CLIENT_SECRET",
  enterpriseId: "YOUR_ENTERPRISE_ID"
)
let auth = BoxCCGAuth(config: config)
let client = BoxClient(auth: auth)
```

#### User Token Acquisition

**Legacy (`Box iOS SDK`):**

```swift
let sdk = BoxSDK(clientId: "YOUR_CLIENT_SECRET", clientSecret: "YOUR_CLIENT_SECRET")
let client = try await sdk.getCCGClientForUser(userId: "YOUR_USER_ID")
```

**Modern (`Box Swift SDK`):**

```swift
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

**Modern (`Box Swift SDK`):**

```swift
auth.asEnterprise(enterpriseId: "YOUR_ENTERPRISE_ID")
```

### OAuth 2.0 Authentication

Using an auth code is the most common way of authenticating with the Box API for existing Box users, to integrate with their accounts.

#### Built-in flow

Both the old SDK and the new one provide a built-in flow for opening a secure web view, into which the user enters their Box login credentials.
However, let's examine the differences between them.

**Legacy (`Box iOS SDK`):**

```swift
let sdk = BoxSDK(clientId: "YOUR_CLIENT_ID", clientSecret: "YOUR_CLIENT_SECRET", callbackURL: "YOUR_REDIRECT_URL")
let client = try await sdk.getOAuth2Client(tokenStore: KeychainTokenStore())
```

**Modern (`Box Swift SDK`):**

```swift
let config = OAuthConfig(clientId: "YOUR_CLIENT_ID", clientSecret: "YOUR_CLIENT_SECRET", tokenStorage: KeychainTokenStorage())
let oauth = BoxOAuth(config: config)
try await oauth.runLoginFlow(options: AuthorizeUrlParams(redirectUri: "YOUR_REDIRECT_URL"), context: self)

let client = BoxClient(auth: oauth)
```

#### Manual flow

As an alternative to the built-in flow, where everything is done automatically, you can opt for the manual one, which has been added only to the new `Box Swift SDK`.

##### Get Authorization URL

First, you need to create the authorization URL based on the provided client data and redirect the user to this URL.

```swift
let config = OAuthConfig(clientId: "YOUR_CLIENT_ID", clientSecret: "YOUR_CLIENT_SECRET")
let authorizationUrl = auth.getAuthorizeUrl()
```

##### Authentication

After a user logs in and grants your application access to their Box account, they will be redirected to your application's `redirectUri` which will contain an authorization code.
This code can then be used along with your client ID and client secret to establish an API connection.
You need to provide the authorization code to the SDK to obtain an access token, then you can use the SDK as usual.

```swift
auth.getTokensAuthorizationCodeGrant(authorizationCode: "YOUR_AUTHORIZATION_CODE")
let client = BoxClient(auth: oauth)
```

### Customizable Token Storage

Both the old and the new SDK allow for the creation of a custom Token Storage, which can be provided when creating an instance of the `AuthConfig` class.

However, let's examine the differences in their implementation.

**Legacy (`Box iOS SDK`):**

In the old SDK, the custom token storage must conform to the `TokenStore` protocol, with the API of the methods being callback-based:

```swift
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

**Modern (`Box Swift SDK`):**

In the new SDK, a custom token storage must conform to the `TokenStore`, where the API is async/await:

```swift
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

**Legacy (`Box iOS SDK`):**

```swift
client.exchangeToken(scope: ["item_preview"], resource: "https://api.box.com/2.0/files/123456789") { result in
    guard case let .success(tokenInfo) = result else {
        print("Error exchanging tokens")
        return
    }

    // tokenInfo contains the downscoped accessToken
    print("Got new access token: \(tokenInfo.accessToken)")
}
```

**Modern (`Box Swift SDK`):**

In the `Box Swift SDK`, downscoping is available only for OAuth and CCG authentication.
Therefore, to downscope a token, we need to call the `downscopeToken` method directly on an instance of the `BoxOAuth` or `BoxCCGAuth` class, and not on the client instance as was the case in the old SDK.

```swift
let accessToken: AccessToken = try await auth.downscopeToken(scopes: ["item_preview"], resource: "https://api.box.com/2.0/files/123456789")
```

### Revoking Tokens

**Legacy (`Box iOS SDK`):**

```swift
client.destroy() { result in
    guard case .success = result else {
        print("Tokens could not be revoked!")
    }

    print("Tokens were successfully revoked")
}
```

**Modern (`Box Swift SDK`):**

Similarly to downscoping, revoke is available only for OAuth and CCG authentication.

```swift
try await auth.revokeToken()
```
