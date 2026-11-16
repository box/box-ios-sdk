import Foundation

/// Builds the request body. The network client calls it to get a fresh body when retrying a request whose body cannot be resent, e.g. one containing a one-time JWT assertion.
public protocol RequestDataFactory {
    /// Creates a new request body
    /// - Returns: The `SerializedData`.
    /// - Throws: The `GeneralError`.
    func create() throws -> SerializedData

}
