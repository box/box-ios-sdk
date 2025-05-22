import Foundation

/// A real-time server that can be used for
/// long polling user events
public class RealtimeServer: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case url
        case ttl
        case maxRetries = "max_retries"
        case retryTimeout = "retry_timeout"
    }

    /// `realtime_server`
    public let type: String?

    /// The URL for the server.
    public let url: String?

    /// The time in minutes for which this server is available
    public let ttl: String?

    /// The maximum number of retries this server will
    /// allow before a new long poll should be started by
    /// getting a [new list of server](#options-events).
    public let maxRetries: String?

    /// The maximum number of seconds without a response
    /// after which you should retry the long poll connection.
    /// 
    /// This helps to overcome network issues where the long
    /// poll looks to be working but no packages are coming
    /// through.
    public let retryTimeout: Int64?

    /// Initializer for a RealtimeServer.
    ///
    /// - Parameters:
    ///   - type: `realtime_server`
    ///   - url: The URL for the server.
    ///   - ttl: The time in minutes for which this server is available
    ///   - maxRetries: The maximum number of retries this server will
    ///     allow before a new long poll should be started by
    ///     getting a [new list of server](#options-events).
    ///   - retryTimeout: The maximum number of seconds without a response
    ///     after which you should retry the long poll connection.
    ///     
    ///     This helps to overcome network issues where the long
    ///     poll looks to be working but no packages are coming
    ///     through.
    public init(type: String? = nil, url: String? = nil, ttl: String? = nil, maxRetries: String? = nil, retryTimeout: Int64? = nil) {
        self.type = type
        self.url = url
        self.ttl = ttl
        self.maxRetries = maxRetries
        self.retryTimeout = retryTimeout
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        ttl = try container.decodeIfPresent(String.self, forKey: .ttl)
        maxRetries = try container.decodeIfPresent(String.self, forKey: .maxRetries)
        retryTimeout = try container.decodeIfPresent(Int64.self, forKey: .retryTimeout)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encodeIfPresent(ttl, forKey: .ttl)
        try container.encodeIfPresent(maxRetries, forKey: .maxRetries)
        try container.encodeIfPresent(retryTimeout, forKey: .retryTimeout)
    }

}
