import Foundation

/// The request body for updating a shuttle system. Only the fields supplied are
/// changed.
public class ShuttleSystemUpdateRequestV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case name
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The updated display name for the shuttle system.
    public let name: String?

    /// Initializer for a ShuttleSystemUpdateRequestV2026R0.
    ///
    /// - Parameters:
    ///   - name: The updated display name for the shuttle system.
    public init(name: String? = nil) {
        self.name = name
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
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
