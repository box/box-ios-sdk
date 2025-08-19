import Foundation

/// An app item represents an content object owned by an application. It can
/// group files and folders together from different paths. That set can be shared
/// via a collaboration.
public class AppItem: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case applicationType = "application_type"
        case type
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier for this app item.
    public let id: String

    /// The type of the app that owns this app item.
    public let applicationType: String

    /// The value will always be `app_item`.
    public let type: AppItemTypeField

    /// Initializer for a AppItem.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this app item.
    ///   - applicationType: The type of the app that owns this app item.
    ///   - type: The value will always be `app_item`.
    public init(id: String, applicationType: String, type: AppItemTypeField = AppItemTypeField.appItem) {
        self.id = id
        self.applicationType = applicationType
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        applicationType = try container.decode(String.self, forKey: .applicationType)
        type = try container.decode(AppItemTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(applicationType, forKey: .applicationType)
        try container.encode(type, forKey: .type)
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
