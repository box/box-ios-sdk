import Foundation

public class ZipDownloadRequestItemsField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case type
        case id
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The type of the item to add to the archive.
    public let type: ZipDownloadRequestItemsTypeField

    /// The identifier of the item to add to the archive. When this item is
    /// a folder then this can not be the root folder with ID `0`.
    public let id: String

    /// Initializer for a ZipDownloadRequestItemsField.
    ///
    /// - Parameters:
    ///   - type: The type of the item to add to the archive.
    ///   - id: The identifier of the item to add to the archive. When this item is
    ///     a folder then this can not be the root folder with ID `0`.
    public init(type: ZipDownloadRequestItemsTypeField, id: String) {
        self.type = type
        self.id = id
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(ZipDownloadRequestItemsTypeField.self, forKey: .type)
        id = try container.decode(String.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(id, forKey: .id)
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
