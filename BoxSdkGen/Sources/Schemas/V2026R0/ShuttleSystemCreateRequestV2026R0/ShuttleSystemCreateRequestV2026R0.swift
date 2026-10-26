import Foundation

/// The request body for creating a shuttle system. Only Windows agent systems
/// can be created through the public API, so `system_type` must be `windows`.
public class ShuttleSystemCreateRequestV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case name
        case systemType = "system_type"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The display name for the new shuttle system.
    public let name: String

    /// The public system type identifier for the new shuttle system. Only
    /// `windows` is currently supported through the public API.
    public let systemType: ShuttleSystemCreateRequestV2026R0SystemTypeField

    /// Initializer for a ShuttleSystemCreateRequestV2026R0.
    ///
    /// - Parameters:
    ///   - name: The display name for the new shuttle system.
    ///   - systemType: The public system type identifier for the new shuttle system. Only
    ///     `windows` is currently supported through the public API.
    public init(name: String, systemType: ShuttleSystemCreateRequestV2026R0SystemTypeField = ShuttleSystemCreateRequestV2026R0SystemTypeField.windows) {
        self.name = name
        self.systemType = systemType
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        systemType = try container.decode(ShuttleSystemCreateRequestV2026R0SystemTypeField.self, forKey: .systemType)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(systemType, forKey: .systemType)
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
