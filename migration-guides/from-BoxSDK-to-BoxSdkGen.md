# Migration guide: migrate from `BoxSDK` module to `BoxSdkGen` module

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Introduction](#introduction)
  - [Who is this for?](#who-is-this-for)
- [Migration at a glance](#migration-at-a-glance)
- [Key API differences](#key-api-differences)
  - [Import statements](#import-statements)
  - [Async/await support](#asyncawait-support)
  - [Consistent method signatures](#consistent-method-signatures)
- [Authentication](#authentication)
  - [Developer Token](#developer-token)
  - [Client Credentials Grant](#client-credentials-grant)
    - [Service Account Token Acquisition](#service-account-token-acquisition)
    - [User Token Acquisition](#user-token-acquisition)
    - [Switching between Service Account and User](#switching-between-service-account-and-user)
  - [OAuth 2.0 Authentication](#oauth-20-authentication)
    - [Built-in flow](#built-in-flow)
    - [Manual flow](#manual-flow)
  - [Customizable Token Storage](#customizable-token-storage)
  - [Downscoping Tokens](#downscoping-tokens)
  - [Revoking Tokens](#revoking-tokens)
- [Configuration](#configuration)
  - [As-User header](#as-user-header)
  - [Custom Base URLs](#custom-base-urls)
  - [Extra headers](#extra-headers)
- [Convenience methods](#convenience-methods)
  - [Chunked upload of big files](#chunked-upload-of-big-files)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Introduction

Version availability:

- v5: ships only `BoxSDK` module
- v6: ships both `BoxSDK` and `BoxSdkGen` modules (side-by-side)
- v10+: ships only `BoxSdkGen` module

This document focuses on helping you migrate code from the legacy `BoxSDK` module to the generated `BoxSdkGen` module. Many APIs were redesigned for consistency and modern Swift patterns, so this guide calls out how to adopt the new shapes safely and incrementally.

Supported migration paths:

- v5 → v6: adopt `BoxSdkGen` gradually while legacy code still uses `BoxSDK`
- v5 → v10+: migrate directly to `BoxSdkGen` only
- v6 (within the same app): move usage from `BoxSDK` to `BoxSdkGen` file-by-file

For comprehensive API docs with sample code for all methods, see the repository documentation in the root `docs` directory: [`docs/`](../docs/).

Recommended direction: use `BoxSdkGen` going forward. Because it is auto-generated from the Box OpenAPI specification, it:

- Provides first-class async/await support across the API surface
- Uses consistent method signatures with grouped parameters (path, body, query, headers)
- Ships new features and fixes faster and with higher parity with the Box API
- Offers richer convenience methods (for example, chunked uploads)
- Improves type-safety and long-term maintainability

### Who is this for?

- Teams with existing code using `BoxSDK` who want to start calling `BoxSdkGen` APIs.
- Teams already on an SDK release that provides both modules and want to transition usage from `BoxSDK` to `BoxSdkGen` within the same app.

## Migration at a glance

- Replace `import BoxSDK` with `import BoxSdkGen` in files you’re migrating.
- Convert callback-based code to async/await.
- Update method calls to the new, consistent signatures that group parameters by path, body, query and headers.
- For OAuth or CCG, interact with tokens via the auth instance (`BoxOAuth`/`BoxCCGAuth`) instead of the client.

## Key API differences

This section compares the manually-maintained `BoxSDK` module with the generated `BoxSdkGen` module so you can quickly adopt the new APIs.

### Import statements

- BoxSDK:

```swift
import BoxSDK
```

- BoxSdkGen:

```swift
import BoxSdkGen
```

Using different import statements lets you transition file-by-file.

### Async/await support

`BoxSdkGen` adopts async/await for all API methods.

- BoxSDK (callback-based):

```swift
import BoxSDK

client.users.getCurrent(fields: ["name", "login"]) { result in
    guard case let .success(user) = result else {
        print("Error getting user information")
        return
    }

    print("Authenticated as \(user.name), with login \(user.login)")
}
```

- BoxSdkGen (async/await):

```swift
import BoxSdkGen

let user = try await client.users.getUserMe()
```

### Consistent method signatures

To make the API easier to use, `BoxSdkGen` groups parameters by their nature (path, body, query, headers).

- BoxSDK (many parameters):

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

- BoxSdkGen (grouped arguments):

```swift
import BoxSdkGen

public func updateFileById(
    fileId: String,
    requestBody: UpdateFileByIdRequestBodyArg = UpdateFileByIdRequestBodyArg(),
    queryParams: UpdateFileByIdQueryParamsArg = UpdateFileByIdQueryParamsArg(),
    headers: UpdateFileByIdHeadersArg = UpdateFileByIdHeadersArg()
) async throws -> FileFull
```

## Authentication

Authentication is a crucial aspect of any SDK. Below are the differences in usage between `BoxSDK` and `BoxSdkGen`:

### Developer Token

- BoxSDK:

```swift
import BoxSDK

let client = BoxSDK.getClient(token: "YOUR_DEVELOPER_TOKEN")
```

- BoxSdkGen:

```swift
import BoxSdkGen

let auth = BoxDeveloperTokenAuth(token: "YOUR_DEVELOPER_TOKEN")
let client = BoxClient(auth: auth)
```

### Client Credentials Grant

#### Service Account Token Acquisition

- BoxSDK:

```swift
import BoxSDK

let sdk = BoxSDK(clientId: "YOUR_CLIENT_ID", clientSecret: "YOUR_CLIENT_SECRET")
let client = try await sdk.getCCGClientForAccountService(enterpriseId: "YOUR_ENTERPRISE_ID")
```

- BoxSdkGen:

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

- BoxSDK:

```swift
import BoxSDK

let sdk = BoxSDK(clientId: "YOUR_CLIENT_ID", clientSecret: "YOUR_CLIENT_SECRET")
let client = try await sdk.getCCGClientForUser(userId: "YOUR_USER_ID")
```

- BoxSdkGen:

```swift
import BoxSdkGen

let config = CCGConfig(
  clientId: "YOUR_CLIENT_ID",
  clientSecret: "YOUR_CLIENT_SECRET",
  userId: "YOUR_USER_ID"
)
let auth = BoxCCGAuth(config: config)
let client = BoxClient(auth: auth)
```

#### Switching between Service Account and User

- BoxSdkGen:

```swift
import BoxSdkGen

auth.asEnterprise(enterpriseId: "YOUR_ENTERPRISE_ID")
```

### OAuth 2.0 Authentication

Using an auth code is a common way of authenticating with the Box API for existing Box users.

#### Built-in flow

- BoxSDK:

```swift
import BoxSDK

let sdk = BoxSDK(clientId: "YOUR_CLIENT_ID", clientSecret: "YOUR_CLIENT_SECRET", callbackURL: "YOUR_REDIRECT_URL")
let client = try await sdk.getOAuth2Client(tokenStore: KeychainTokenStore())
```

- BoxSdkGen:

```swift
import BoxSdkGen

let config = OAuthConfig(clientId: "YOUR_CLIENT_ID", clientSecret: "YOUR_CLIENT_SECRET", tokenStorage: KeychainTokenStorage())
let oauth = BoxOAuth(config: config)
try await oauth.runLoginFlow(options: AuthorizeUrlParams(redirectUri: "YOUR_REDIRECT_URL"), context: self)

let client = BoxClient(auth: oauth)
```

#### Manual flow

- BoxSdkGen:

```swift
import BoxSdkGen

let config = OAuthConfig(clientId: "YOUR_CLIENT_ID", clientSecret: "YOUR_CLIENT_SECRET")
let oauth = BoxOAuth(config: config)
let authorizationUrl = oauth.getAuthorizeUrl()
```

After the redirect with an authorization code:

```swift
import BoxSdkGen

try await oauth.getTokensAuthorizationCodeGrant(authorizationCode: "YOUR_AUTHORIZATION_CODE")
let client = BoxClient(auth: oauth)
```

### Customizable Token Storage

Both modules allow you to provide custom token storage on `AuthConfig`, but the APIs differ.

- BoxSDK (callbacks):

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

- BoxSdkGen (async/await):

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

Downscoping exchanges an existing Access Token for a new one that is more restricted.

- BoxSDK:

```swift
import BoxSDK

client.exchangeToken(scope: ["item_preview"], resource: "https://api.box.com/2.0/files/123456789") { result in
    guard case let .success(tokenInfo) = result else {
        print("Error exchanging tokens")
        return
    }

    print("Got new access token: \(tokenInfo.accessToken)")
}
```

- BoxSdkGen:

```swift
import BoxSdkGen

let accessToken: AccessToken = try await auth.downscopeToken(scopes: ["item_preview"], resource: "https://api.box.com/2.0/files/123456789")
```

### Revoking Tokens

- BoxSDK:

```swift
import BoxSDK

client.destroy() { result in
    guard case .success = result else {
        print("Tokens could not be revoked!")
        return
    }

    print("Tokens were successfully revoked")
}
```

- BoxSdkGen:

```swift
import BoxSdkGen

try await auth.revokeToken()
```

## Configuration

### As-User header

The As-User header is used by enterprise admins to make API calls on behalf of their enterprise's users.
This requires the API request to pass an `As-User: USER-ID` header. The following examples assume that the client has
been instantiated with an access token with appropriate privileges to make As-User calls.

- BoxSDK:

```swift
import BoxSDK

let asUserClient = client.asUser(withId: "<USER_ID>")
```

- BoxSdkGen:

```swift
import BoxSdkGen

let userClient: BoxClient = client.withAsUserHeader(userId: "<USER_ID>")
```

### Custom Base URLs

- BoxSDK:

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

- BoxSdkGen:

```swift
import BoxSdkGen

let newClient = client.withCustomBaseUrls(baseUrls: BaseUrls(
  baseUrl: "https://api.box.com",
  uploadUrl: "https://upload.box.com/api",
  oauth2Url: "https://account.box.com/api/oauth2"
))
```

### Extra headers

You can specify a custom set of headers included in every API call made by the client.

```swift
import BoxSdkGen

let clientWithHeaders: BoxClient = client.withExtraHeaders(extraHeaders: ["my-custom-header": "my-custom-value"])
```

## Convenience methods

### Chunked upload of big files

For large files or unreliable networks, you may want to upload the file in parts.
This allows a single part to fail without aborting the entire upload, and failed parts are retried automatically.

- BoxSDK (manual multi-call flow)
- BoxSdkGen (single API):

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
