import Foundation

/// Network settings that allow you to configure things such as retryStrategy, maxRetryAttempts.
public class NetworkSettings {
    /// The default number of times a failing request will be retried.
    public static let defaultMaxRetryAttempts: Int = 5

    /// Maximum number of retries for a failed request.
    public let maxRetryAttempts: Int

    /// Retry strategy used when retrying HTTP request.
    public let retryStrategy: RetryStrategyProtocol

    /// Initializer
    ///
    /// - Parameters:
    ///   - maxRetryAttempts: Maximum number of retries for a failed request.
    ///   - retryStrategy: Retry strategy used when retrying HTTP request.
    public init(
        maxRetryAttempts: Int = NetworkSettings.defaultMaxRetryAttempts,
        retryStrategy: RetryStrategyProtocol = ExponentialBackoffRetryStrategy()
    ) {
        self.maxRetryAttempts = maxRetryAttempts
        self.retryStrategy = retryStrategy
    }
}
