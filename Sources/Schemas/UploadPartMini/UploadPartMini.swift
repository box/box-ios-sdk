import Foundation

/// The basic representation of an upload
/// session chunk.
public class UploadPartMini: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case partId = "part_id"
        case offset
        case size
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique ID of the chunk.
    public let partId: String?

    /// The offset of the chunk within the file
    /// in bytes. The lower bound of the position
    /// of the chunk within the file.
    public let offset: Int64?

    /// The size of the chunk in bytes.
    public let size: Int64?

    /// Initializer for a UploadPartMini.
    ///
    /// - Parameters:
    ///   - partId: The unique ID of the chunk.
    ///   - offset: The offset of the chunk within the file
    ///     in bytes. The lower bound of the position
    ///     of the chunk within the file.
    ///   - size: The size of the chunk in bytes.
    public init(partId: String? = nil, offset: Int64? = nil, size: Int64? = nil) {
        self.partId = partId
        self.offset = offset
        self.size = size
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        partId = try container.decodeIfPresent(String.self, forKey: .partId)
        offset = try container.decodeIfPresent(Int64.self, forKey: .offset)
        size = try container.decodeIfPresent(Int64.self, forKey: .size)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(partId, forKey: .partId)
        try container.encodeIfPresent(offset, forKey: .offset)
        try container.encodeIfPresent(size, forKey: .size)
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
