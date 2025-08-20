import Foundation

/// Retry strategy used when retrying HTTP request.
public protocol RetryStrategyProtocol {

    /// Returns the duration in seconds to wait before retrying the request.
    ///
    /// - Parameters:
    ///   - attempt: The retry number.
    /// - Returns: The duration in seconds to wait before retrying the request.
    func getRetryTimeout(attempt: Int) -> TimeInterval
}

/// Exponential backoff retry strategy
public class ExponentialBackoffRetryStrategy:  RetryStrategyProtocol {
    /// The default base interval used to calculating retry timeout.
    public static let defaultBaseInterval: TimeInterval = 1.0
    /// The default base randomization factor used for calculating retry timeout.
    public static let defaultRandomizationFactor: TimeInterval = 0.5

    /// Base interval used to calculating retry timeout.
    private let baseInterval: TimeInterval
    /// Base randomization factor used to calculating retry timeout.
    private let randomizationFactor: TimeInterval

    /// Initializer
    ///
    /// - Parameters:
    ///   - baseInterval: Base interval used to calculating retry timeout.
    ///   - randomizationFactor: Base randomization factor used to calculating retry timeout.
    public init(
        baseInterval: TimeInterval = ExponentialBackoffRetryStrategy.defaultBaseInterval,
        randomizationFactor: TimeInterval = ExponentialBackoffRetryStrategy.defaultRandomizationFactor
    ) {
        self.baseInterval = baseInterval
        self.randomizationFactor = randomizationFactor
    }

    /// Returns the duration in seconds to wait before retrying the request.
    ///
    /// - Parameters:
    ///   - attempt: The retry number.
    /// - Returns: The duration in seconds to wait before retrying the request.
    public func getRetryTimeout(attempt: Int) -> TimeInterval {
        let min = max(1 - self.randomizationFactor, 0)
        let max = max(1 + self.randomizationFactor, 1)

        let jitter = Double.random(in: min ... max)
        let expFactor = pow(2.0, Double(attempt - 1))

        return self.baseInterval * jitter * expFactor
    }
}
