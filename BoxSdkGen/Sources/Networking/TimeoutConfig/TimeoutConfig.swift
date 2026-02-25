import Foundation

public class TimeoutConfig {
    public let timeoutIntervalForRequestMs: Int64?

    public let timeoutIntervalForResourceMs: Int64?

    public init(timeoutIntervalForRequestMs: Int64? = nil, timeoutIntervalForResourceMs: Int64? = nil) {
        self.timeoutIntervalForRequestMs = timeoutIntervalForRequestMs
        self.timeoutIntervalForResourceMs = timeoutIntervalForResourceMs
    }

}
