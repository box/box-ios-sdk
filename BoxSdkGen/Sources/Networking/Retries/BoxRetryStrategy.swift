import Foundation

public class BoxRetryStrategy: RetryStrategy {
    public let maxAttempts: Int

    public let retryRandomizationFactor: Double

    public let retryBaseInterval: Double

    public let maxRetriesOnException: Int

    public init(maxAttempts: Int = 5, retryRandomizationFactor: Double = 0.5, retryBaseInterval: Double = 1, maxRetriesOnException: Int = 2) {
        self.maxAttempts = maxAttempts
        self.retryRandomizationFactor = retryRandomizationFactor
        self.retryBaseInterval = retryBaseInterval
        self.maxRetriesOnException = maxRetriesOnException
    }

    public func shouldRetry(fetchOptions: FetchOptions, fetchResponse: FetchResponse, attemptNumber: Int) async throws -> Bool {
        if fetchResponse.status == 0 {
            return attemptNumber <= self.maxRetriesOnException
        }

        let isSuccessful: Bool = fetchResponse.status >= 200 && fetchResponse.status < 400
        let retryAfterHeader: String? = fetchResponse.headers["Retry-After"]
        let isAcceptedWithRetryAfter: Bool = fetchResponse.status == 202 && retryAfterHeader != nil
        if attemptNumber >= self.maxAttempts {
            return false
        }

        if isAcceptedWithRetryAfter {
            return true
        }

        if fetchResponse.status >= 500 {
            return true
        }

        if fetchResponse.status == 429 {
            return true
        }

        if fetchResponse.status == 401 && fetchOptions.auth != nil {
            let auth: Authentication = fetchOptions.auth!
            try await auth.refreshToken(networkSession: fetchOptions.networkSession)
            return true
        }

        if isSuccessful {
            return false
        }

        return false
    }

    public func retryAfter(fetchOptions: FetchOptions, fetchResponse: FetchResponse, attemptNumber: Int) -> Double {
        let retryAfterHeader: String? = fetchResponse.headers["Retry-After"]
        if retryAfterHeader != nil {
            return Double(retryAfterHeader!)!
        }

        let randomization: Double = Utils.random(min: 1 - self.retryRandomizationFactor, max: 1 + self.retryRandomizationFactor)
        let exponential: Double = pow(2, Double(attemptNumber))
        return exponential * self.retryBaseInterval * randomization
    }

}
