import Foundation

/// TokenStorage which keeps AccessToken directly in memory.
public class InMemoryTokenStorage: TokenStorage {

    /// Access token
    private var token: AccessToken?

    public init(token: AccessToken? = nil) {
        self.token = token
    }

    /// Store access token in memory
    ///
    /// - Parameters:
    ///   - token: The access token to store
    public func store(token: AccessToken) async throws {
        self.token = token
    }

    /// Get access token from memory
    ///
    /// - Returns: The stored access token
    public func get() async throws -> AccessToken? {
        return self.token
    }

    /// Clear access token in memory
    public func clear() async throws {
        self.token = nil
    }
}
