Authentication
==============

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Ways to Authenticate](#ways-to-authenticate)
  - [Developer Token](#developer-token)
  - [Server Auth with JWT](#server-auth-with-jwt)
  - [Traditional 3-Legged OAuth2](#traditional-3-legged-oauth2)
- [Token Store](#token-store)
- [As-User](#as-user)
- [Token Exchange](#token-exchange)
- [Revoking Tokens](#revoking-tokens)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

The Box API uses two flavors of OAuth2 for authentication, both of which can can be difficult to implement.
The SDK makes it easier by providing classes that handle obtaining tokens and
automatically refreshing them when possible. See the [Auth Types documentation](https://developer.box.com/docs/authentication-types-and-security)
for a detailed overview of how the Box API handles authentication and how to choose between the different authentication
types.

Ways to Authenticate
--------------------

### Developer Token

The fastest way to get started using the API is with developer tokens. A developer token is a short-lived access
token that cannot be refreshed and can only be used with your own account. Therefore, they're only useful for testing
an app and aren't suitable for use in production. You can obtain a developer token from your application's
[developer console][dev-console] page.

The following example creates an SDK client with a developer token:
```swift
import BoxSDK

let client = BoxSDK.getClient(token: "YOUR_DEVELOPER_TOKEN")
```

[dev-console]: https://app.box.com/developers/console

### Server Auth with JWT

Server auth allows your application to authenticate itself with the Box API for a given enterprise.  By default, your
application has a [Service Account](https://developer.box.com/docs/service-account) that represents it and can perform
API calls.  The Service Account is separate from the Box accounts of the application developer and the enterprise admin
of any enterprise that has authorized the app — files stored in that account are not accessible in any other account by
default, and vice versa.

JWT Authentication requires a private key for signing the JSON Web Token, which is then exchanged for a valid Box access
token that can be used to call the API.  It is not secure to store this private key in a mobile app that is publicly
distributed, so in order to use JWT Authentication the SDK requires that generation of the access token happens in some
other service or process.  The SDK can then make a request to that service for access tokens to use.

To use the SDK with JWT Auth, you'll need to provide a block of code that is responsible for requesting a new
token when one is needed.  This block can call out to a web service or other endpoint that is responsible for generating
the token.  The block receives the unique ID of the user who needs to be authenticated, and a completion function to
call with the results of the authentication.

```swift
import BoxSDK

let sdk = BoxSDK(clientId: "YOUR CLIENT ID HERE", clientSecret: "YOUR CLIENT SECRET HERE")

func getTokensFromAuthServer(uniqueID: String, completion: @escaping (Result<AccessTokenTuple, Error>) -> Void) {
    // Call auth service with unique ID; it passes back the access token and time-to-live (TTL) in seconds
    completion(.success((accessToken: accessToken, expiresIn: accessTokenTTLinSeconds)))
}

// Create client with unique ID — note that this can be any value your application understands.  The unique
// ID is a mechanism for your application to keep track of or map your users to Box
sdk.getDelegatedAuthClient(authClosure: getTokensFromAuthServer, uniqueID: "myUser12345") { result in
    switch result {
    case let .success(client):
        // Use client to make API calls
    case let .failure(error):
        // Handle error creating client
    }
}
```

### Traditional 3-Legged OAuth2

If your application needs to integrate with existing Box users who will provide their login credentials to grant your
application access to their account, you will need to go through the standard OAuth2 login flow.  A detailed guide for
this process is available in the [Authentication with OAuth API documentation](https://developer.box.com/docs/oauth-20).

Using an auth code is the most common way of authenticating with the Box API for existing Box users, to integrate with
their accounts.  The SDK provides a built-in flow for opening a secure web view, into which the user enters their Box
login credentials.  This requires that the application using the SDK registers itself for a custom URL scheme of the
format `boxsdk-<<CLIENT ID>>://boxsdkoauth2redirect`.

<!-- sample get_authorize -->
```swift
import BoxSDK

let sdk = BoxSDK(clientId: "YOUR CLIENT ID HERE", clientSecret: "YOUR CLIENT SECRET HERE")
sdk.getOAuth2Client() { result in
    switch result {
    case let .success(client):
        // Use client to make API calls
    case let .failure(error):
        // Handle error creating client
    }
}
```

Token Store
-----------

In order to maintain authentication and ensure that your users do not need to log in again every time they use your
application, you should persist their token information to some sort of durable store (e.g. the Keychain).  The SDK
provides a `TokenStore` interface which allows you to read and write tokens to whatever store your application uses at
the correct points in the SDK's token handling logic.  The interface requires three methods:

The SDK provides a default `KeychainTokenStore` implementation that stores the user's tokens on the device Keychain,
but you can also create your own custom token store by implementing something that conforms to the `TokenStore`
protocol:
```swift
// The token store constructor should create a specific store instance for the user being authenticated — it may need
// to take in a user ID or other unique identifier

public protocol TokenStore {

    // Read the user's tokens from the data store and pass them to the completion
    func read(completion: @escaping (Result<TokenInfo, Error>) -> Void)

    // Write the token information to the store.  The tokenInfo argument can be serialized for storage.
    // Call the completion after the write has completed.
    func write(tokenInfo: TokenInfo, completion: @escaping (Result<Void, Error>) -> Void)

    // Delete the user's token information from the store, and call the completion after the write.
    func clear(completion: @escaping (Result<Void, Error>) -> Void)
}
```

As-User
-------

The `As-User` header is used to make API calls from one user account on behalf of another user.  This is used by
enterprise administrators and Service Accounts to make API calls on behalf of managed users or app users. This requires
the API request to contain an `As-User: USER-ID` header with each API call, which the SDK handles automatically. For more
details, see the [documentation on As-User](https://developer.box.com/reference#as-user-1).

The following examples assume that the `client` has been instantiated with an access token belonging to an admin-role
user or Service Account with appropriate privileges to make As-User calls.

The `BoxClient#asUser(withId: String)` method clones the client to impersonate a given user.  Note that a new client
is created, and the original client instance is left unmodified.  All calls made with the new instance of client will be
made in context of the impersonated user.

```swift
let asUserClient = client.asUser(withId: "USER ID");
asUserClient.users.getCurrentUser() { result in
    guard case let .success(user) = result else {
        print("Could not retrieve user info!")
        return
    }

    print("Call was made as \(user.name) (\(user.login))")
}
```

Token Exchange
--------------

You can exchange a client's access token for one with a lower scope, in order to restrict the permissions for a child
client or to pass to a less secure location (e.g. a browser-based app).

To exchange the token held by a client for a new token with only `item_preview`
scope, restricted to a single file:

```swift
client.exchangeToken(scope: ["item_preview"], resource: "https://api.box.com/2.0/files/123456789") { result in
    guard case let .success(tokenInfo) = result else {
        print("Error exchanging tokens")
        return
    }

    print("Got new access token: \(tokenInfo.accessToken)")
}
```

Revoking Tokens
---------------

Access tokens for a client can be revoked when needed.  This removes the client's authentication, and the client can no
longer be used after this operation.

```swift
client.destroy() { result in
    guard case .success = result else {
        print("Tokens could not be revoked!")
    }

    print("Tokens were successfully revoked")
}
```
