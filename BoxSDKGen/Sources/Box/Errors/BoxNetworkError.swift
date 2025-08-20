import Foundation

/// Describes network related errors.
public class BoxNetworkError: BoxSDKError {

    /// Initializer
    ///
    /// - Parameters:
    ///   - message: Error message
    ///   - error: The underlying error which caused this error, if any.
    public init(message: String, timestamp: Date? = nil, error: Error? = nil) {
        super.init(message: message, timestamp: timestamp, error: error, name: "BoxNetworkError")
    }
}
