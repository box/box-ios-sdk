# Configuration

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Configuration](#configuration)
  - [Max retry attempts](#max-retry-attempts)
  - [Custom retry strategy](#custom-retry-strategy)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Max retry attempts

The default maximum number of retries in case of failed API call is 5.
To change this number you should initialize `BoxRetryStrategy` with the new value and pass it to `NetworkSession`.

```swift
let networkSession: NetworkSession = NetworkSession(
    retryStrategy: BoxRetryStrategy(maxAttempts: 5)
)
let auth: BoxDeveloperTokenAuth = BoxDeveloperTokenAuth(token: "DEVELOPER_TOKEN");
let client: BoxClient = BoxClient(auth: auth, networkSession: networkSession)
```

## Custom retry strategy

You can also implement your own retry strategy class by conforming to `RetryStrategy` protocol and providing the implementation for `shouldRetry` and `retryAfter` methods.
This example shows how to set custom strategy that retries on 5xx status codes and waits 1 second between retries.

```swift
public class CustomRetryStrategy: RetryStrategy {
    public func shouldRetry(fetchOptions: FetchOptions, fetchResponse: FetchResponse, attemptNumber: Int) async throws -> Bool {
        return fetchResponse.status >= 500
    }

    public func retryAfter(fetchOptions: FetchOptions, fetchResponse: FetchResponse, attemptNumber: Int) -> Double {
        return 1.0
    }
}

let networkSession: NetworkSession = NetworkSession(
    retryStrategy: CustomRetryStrategy()
)
let auth: BoxDeveloperTokenAuth = BoxDeveloperTokenAuth(token: "DEVELOPER_TOKEN")
let client: BoxClient = BoxClient(auth: auth, networkSession: networkSession)
```

As you can see, in this example we based our decision to retry solely on the status code of the response.
However, you can use any information available in `fetchOptions` and `fetchResponse` to make a more informed decision.
