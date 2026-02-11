import Foundation

/// Request body for cancelling a sign request.
public class SignRequestCancelRequest: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case reason
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// An optional reason for cancelling the sign request.
    public let reason: String?

    /// Initializer for a SignRequestCancelRequest.
    ///
    /// - Parameters:
    ///   - reason: An optional reason for cancelling the sign request.
    public init(reason: String? = nil) {
        self.reason = reason
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        reason = try container.decodeIfPresent(String.self, forKey: .reason)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(reason, forKey: .reason)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
