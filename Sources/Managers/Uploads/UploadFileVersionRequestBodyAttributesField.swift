import Foundation

public class UploadFileVersionRequestBodyAttributesField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case name
        case contentModifiedAt = "content_modified_at"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// An optional new name for the file. If specified, the file
    /// will be renamed when the new version is uploaded.
    public let name: String

    /// Defines the time the file was last modified at.
    /// 
    /// If not set, the upload time will be used.
    public let contentModifiedAt: Date?

    /// Initializer for a UploadFileVersionRequestBodyAttributesField.
    ///
    /// - Parameters:
    ///   - name: An optional new name for the file. If specified, the file
    ///     will be renamed when the new version is uploaded.
    ///   - contentModifiedAt: Defines the time the file was last modified at.
    ///     
    ///     If not set, the upload time will be used.
    public init(name: String, contentModifiedAt: Date? = nil) {
        self.name = name
        self.contentModifiedAt = contentModifiedAt
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        contentModifiedAt = try container.decodeDateTimeIfPresent(forKey: .contentModifiedAt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeDateTimeIfPresent(field: contentModifiedAt, forKey: .contentModifiedAt)
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
