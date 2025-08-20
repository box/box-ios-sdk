import Foundation

/// Defines methods for storing access token.
public protocol TokenStorage {

    /// Store access token
    ///
    /// - Parameters:
    ///   - token: The access token to store
    func store(token: AccessToken) async throws

    /// Get access token
    ///
    /// - Returns: The stored access token
    func get() async throws -> AccessToken?

    /// Clear access token
    func clear() async throws
}
