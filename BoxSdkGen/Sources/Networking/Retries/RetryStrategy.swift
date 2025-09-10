import Foundation

public protocol RetryStrategy {
    func shouldRetry(fetchOptions: FetchOptions, fetchResponse: FetchResponse, attemptNumber: Int) async throws -> Bool

    func retryAfter(fetchOptions: FetchOptions, fetchResponse: FetchResponse, attemptNumber: Int) -> Double

}
