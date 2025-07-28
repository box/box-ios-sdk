# Authentication

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Authentication](#authentication)
- [Authentication methods](#authentication-methods)
  - [Developer Token](#developer-token)
  - [Client Credentials Grant](#client-credentials-grant)
    - [Obtaining Service Account token](#obtaining-service-account-token)
    - [Obtaining User token](#obtaining-user-token)
    - [Switching between Service Account and User](#switching-between-service-account-and-user)
  - [OAuth 2.0 Auth](#oauth-20-auth)
    - [Login flow (recommended)](#login-flow-recommended)
    - [Manual flow](#manual-flow)
    - [Injecting existing token into BoxOAuth](#injecting-existing-token-into-boxoauth)
- [Retrieve current access token](#retrieve-current-access-token)
- [Refresh access token](#refresh-access-token)
- [Revoke token](#revoke-token)
- [Downscope token](#downscope-token)
- [Token storage](#token-storage)
  - [In-memory token storage](#in-memory-token-storage)
  - [Keychain token storage](#keychain-token-storage)
  - [Custom storage](#custom-storage)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Authentication methods

## Developer Token

The fastest way to get started using the API is with developer token. A
developer token is simply a short-lived access token that cannot be refreshed
and can only be used with your own account. Therefore, they're only useful for
testing an app and aren't suitable for production. You can obtain a developer
token from your application's [developer console][dev_console] page.

To create a `BoxClient` with a developer token, construct an `BoxDeveloperTokenAuth`
object with the `token` set to the developer token and construct the client with that.

<!-- sample x_auth init_with_dev_token -->

```swift
import BoxSdkGen

let auth = BoxDeveloperTokenAuth(token: "DEVELOPER_TOKEN_GOES_HERE")
let client = BoxClient(auth: auth)

let me = try await client.users.getUserMe()
print("My user ID is \(me.id)")
```

[dev_console]: https://app.box.com/developers/console

## Client Credentials Grant

Before using Client Credentials Grant Auth make sure you set up correctly your Box platform app.
The guide with all required steps can be found here: [Setup with Client Credentials Grant][ccg_guide]

Client Credentials Grant Auth method allows you to obtain an access token by having client credentials
and secret with enterprise or user ID, which allows you to work using service or user account.

You can use `BoxCCGAuth` to initialize a client object the same way as for other authentication types:

```swift
import BoxSdkGen

let config = CCGConfig(
  clientId: "YOUR_CLIENT_ID",
  clientSecret: "YOUR_CLIENT_SECRET",
  userId: "YOUR_USER_ID"
)
let auth = BoxCCGAuth(config: config)
let client = BoxClient(auth: auth)

let user = try await client.users.getUserMe()
print("Id of the authenticated user is \(user.id)")
```

Obtained token is valid for specified amount of time, it will be refreshed automatically by default.

### Obtaining Service Account token

The [Service Account](https://developer.box.com/guides/getting-started/user-types/service-account//)
is separate from the Box accounts of the application developer and the
enterprise admin of any enterprise that has authorized the app — files stored in that account
are not accessible in any other account by default, and vice versa.
To obtain service account you will have to provide enterprise ID with client id and secret:

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

### Obtaining User token

In order to enable obtaining user token you have to go to your application configuration that can be found
[here][dev_console]. In `Configuration` tab, in section `Advanced Features`
select `Generate user access tokens`. Do not forget to re-authorize application if it was already authorized.

To obtain user account you will have to provide user ID with client id and secret.

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

### Switching between Service Account and User

In order to switch between being authenticated as Service Account and a User you can call:

```swift
let enterpriseAuth = auth.withEnterpriseSubject(enterpriseId: "YOUR_ENTERPRISE_ID")
let enterpriseClient = BoxClient(auth: enterpriseAuth)
```

to authenticate as enterprise or

```swift
let userAuth = auth.withUserSubject(userId: "YOUR_USER_ID")
let userClient = BoxClient(auth: userAuth)
```

to authenticate as User with provided ID. The new token will be automatically fetched with a next API call.

[ccg_guide]: https://developer.box.com/guides/authentication/client-credentials/client-credentials-setup/

## OAuth 2.0 Auth

If your application needs to integrate with existing Box users who will provide
their login credentials to grant your application access to their account, you
will need to go through the standard OAuth2 login flow. A detailed guide for
this process is available in the
[Authentication with OAuth API documentation](https://developer.box.com/en/guides/authentication/oauth2/).

Using an auth code is the most common way of authenticating with the Box API for
existing Box users, to integrate with their accounts.

### Login flow (recommended)

The SDK provides a built-in flow for opening a secure web view, into which the user enters their Box
login credentials. This requires that the application using the SDK registers itself for a custom URL scheme of the
format `boxsdk-<<CLIENT ID>>://boxsdkoauth2redirect`.

<!-- sample get_authorize -->

```swift
do {
    // Initialize configuration with required clientId and clientSecret
    let config = OAuthConfig(clientId: "<<YOUR CLIENT ID HERE>>", clientSecret: "<<YOUR CLIENT SECRET HERE>>")
    // Initialize BoxOAuth with configuration
    let oauth = BoxOAuth(config: config)
    // Run login flow which opens a secure web view,
    // where users enter their login credentials to obtain an authorization code,
    // which is then exchanged for an access token.
    try await oauth.runLoginFlow(options: .init(), context: self)
    // Initialize BoxClient with already authorized OAuth
    let client = BoxClient(auth: oauth)

    // Use client to make API calls
    let folder = try await client.folders.getFolderById(folderId: "<<YOUR_FOLDER_ID>>")
} catch {
    print("An error occurred: \(error)")
}
```

If your application requires a custom URL scheme that differs from the default format `boxsdk-<<CLIENT ID>>://boxsdkoauth2redirect`,
you have the option to pass in a custom `redirectUri` string when running the `runLoginFlow()` method:

```swift
try await oauth.runLoginFlow(options: AuthorizeUrlParams(redirectUri: "my-custom-scheme://redirect"), context: self)
```

This is the URL to which Box will redirect the user when authentication completes. This requires that the application using the SDK registers itself for the same custom callback URL.

When running the `runLoginFlow(options:context:)` method, the _context_ parameter is required. It's specify the context to target where in an application's UI the authorization view should be shown.
This parameter is of type `ASWebAuthenticationPresentationContextProviding`, so in order to pass it, you have to adopt the mentioned `ASWebAuthenticationPresentationContextProviding` protocol. If you are running your code from the ViewController, you can add the following code to it:

```swift
extension ViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
}
```

Then in the `context` argument, just pass self as we did in the previous examples.

### Manual flow

As an alternative to login flow, where everything is done automatically, you can use the manual one. This flow requires you to actively obtain an authorization code and pass it to the OAuth for the purpose of exchanging it for an Access Token.

To initiate this flow, you need to create the `authorizationUrl`, based on provided client data, and redirect to this url the user.

```swift
let auth = BoxOAuth(config:
        OAuthConfig(clientId: "<<YOUR CLIENT ID HERE>>", clientSecret: "<<YOUR CLIENT SECRET HERE>>")
)
let authorizationUrl = auth.getAuthorizeUrl()
```

After a user logs in and grants your application access to their Box account,
they will be redirected to your application's `redirectUri` which will contain
an authorization code. This code can then be used along with your client ID and
client secret to establish an API connection.
You need to provide the auth code to the SDK to obtain an access token.
Calling `auth.getTokensAuthorizationCodeGrant(authorizationCode: "<<YOUR_AUTHORIZATION_CODE>>")` will exchange the auth
code for an access token and save it in the `BoxOAuth` token storage. The SDK will automatically refresh
the token when needed.
All you need to do is create a client object with the `BoxOAuth` object and start making API calls.

<!-- sample post_oauth2_token --->

```swift
auth.getTokensAuthorizationCodeGrant(authorizationCode: "<<YOUR_AUTHORIZATION_CODE>>")
let client = BoxClient(auth: auth)
```

### Injecting existing token into BoxOAuth

If you already have an access token and refresh token, you can inject them into the `BoxOAuth` token storage
to avoid repeating the authentication process. This can be useful when you want to reuse the token
between runs of your application.

```swift
let accessToken = AccessToken(accessToken: "<ACCESS_TOKEN>", refreshToken: "<REFRESH_TOKEN>")
try await auth.tokenStorage.store(token: accessToken)
let client = BoxClient(auth: auth)
```

Alternatively, you can create a custom implementation of `TokenStorage` protocol and pass it to the `BoxOAuth` object.
See the [Custom storage](#custom-storage) section for more information.

# Retrieve current access token

After initializing the authentication object, the SDK will be able to retrieve the access token.
To retrieve the current access token you can use the following code:

<!-- sample post_oauth2_token -->

```swift
try await auth.retrieveToken();
```

# Refresh access token

Access tokens are short-lived and need to be refreshed periodically. The SDK will automatically refresh the token when needed.
If you want to manually refresh the token, you can use the following code:

<!-- sample post_oauth2_token refresh -->

```swift
try await auth.refreshToken();
```

# Revoke token

Access tokens for a client can be revoked when needed. This call invalidates old token.
For BoxCCGAuth you can still reuse the `auth` object to retrieve a new token.
If you make any new call after revoking the token, a new token will be automatically retrieved.
For BoxOAuth it would be necessary to manually go through the authentication process again.
For BoxDeveloperTokenAuth, it is necessary to provide a DeveloperTokenConfig during initialization,
containing the client ID and client secret.

To revoke current client's tokens in the storage use the following code:

<!-- sample post_oauth2_revoke -->

```swift
try await auth.revokeToken()
```

# Downscope token

You can exchange an access token for one with a lower scope, in order
to restrict the permissions for a child client or to pass to a less secure
location (e.g. a browser-based app).

A downscoped token does not include a refresh token.
In that case, to get a new downscoped token, refresh the original refresh token and use that new token to get a downscoped token.

More information about downscoping tokens can be found [here](https://developer.box.com/guides/authentication/tokens/downscope/).
If you want to learn more about available scopes please go [here](https://developer.box.com/guides/api-calls/permissions-and-errors/scopes/#scopes-for-downscoping).

For example to get a new token with only `item_preview` scope, restricted to a single file, suitable for the
[Content Preview UI Element](https://developer.box.com/en/guides/embed/ui-elements/preview/) you can the following code:
You can also initialize `BoxDeveloperTokenAuth` with the retrieved access token and use it to create a new Client.

<!-- sample post_oauth2_token downscope_token -->

```swift
let resource = "https://api.box.com/2.0/files/123456789"
let downscopedToken: AccessToken = try await auth.downscopeToken(scopes: ["item_preview"], resource: resource)
let downscopedAuth = BoxDeveloperTokenAuth(token: downscopedToken.accessToken!)
let downscopedClient = BoxClient(auth: downscopedAuth)
```

# Token storage

## In-memory token storage

By default, the SDK stores the access token in volatile memory. When rerunning your application,
the access token won't be reused from the previous run; a new token has to be obtained again.
To use in-memory token storage, you don't need to do anything more than
create an Auth class using AuthConfig, for example, for BoxOAuth:

```swift
let auth = BoxOAuth(config:
        OAuthConfig(clientId: "<<YOUR CLIENT ID HERE>>", clientSecret: "<<YOUR CLIENT SECRET HERE>>")
)
```

## Keychain token storage

If you want to keep an up-to-date access token on Apple's device Keychain, allowing it to be reused after rerunning your application,
you can use the `KeychainTokenStorage` class. To enable storing the token in Keychain, you need to pass an object of type
`KeychainTokenStorage` to the AuthConfig class. For example, for BoxOAuth:

```swift
// Initialize configuration with required clientId, clientSecret and tokenStorage
let config = OAuthConfig(clientId: "<<YOUR CLIENT ID HERE>>", clientSecret: "<<YOUR CLIENT SECRET HERE>>", tokenStorage: KeychainTokenStorage())
// Initialize OAuth with configuration
let oauth = BoxOAuth(config: config)
// Initialize BoxClient
let client = BoxClient(auth: oauth)

// In the case of BoxOAuth authorization, if there is no access token in the keychain,
// you must run the `runLoginFlow` process to retrieve the token which will be automatically stored in TokenStorage.
if try! await storage.get() == nil {
    try await oauth.runLoginFlow(options: AuthorizeUrlParams(redirectUri: "my-custom-scheme://redirect"), context: self)
}
```

## Custom storage

You can also provide a custom token storage class. All you need to do is create a class that implements `TokenStorage`
protocol and pass an instance of your class to the AuthConfig constructor.

```swift
class MyCustomTokenStorage: TokenStorage {
    func store(token: AccessToken) async throws {
        // store token in your custom storage
    }

    func get() async throws -> AccessToken? {
        // retrieve token from your custom storage
    }

    func clear() async throws {
        // clear token from your custom storage
    }
}

let auth = BoxOAuth(config:
        OAuthConfig(
          clientId: "<<YOUR CLIENT ID HERE>>",
          clientSecret: "<<YOUR CLIENT SECRET HERE>>",
          tokenStorage: MyCustomTokenStorage()
          )
)
```
