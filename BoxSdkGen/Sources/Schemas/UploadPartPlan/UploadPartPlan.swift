import Foundation

/// Represents a planned upload part with `SHA-512` hash
/// for upload session planning.
public class UploadPartPlan: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case offset
        case size
        case sha512
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The offset of the chunk within the file
    /// in bytes. The lower bound of the position
    /// of the chunk within the file.
    public let offset: Int64

    /// The size of the chunk in bytes.
    public let size: Int64

    /// The `SHA-512` hash of the chunk.
    public let sha512: String

    /// Initializer for a UploadPartPlan.
    ///
    /// - Parameters:
    ///   - offset: The offset of the chunk within the file
    ///     in bytes. The lower bound of the position
    ///     of the chunk within the file.
    ///   - size: The size of the chunk in bytes.
    ///   - sha512: The `SHA-512` hash of the chunk.
    public init(offset: Int64, size: Int64, sha512: String) {
        self.offset = offset
        self.size = size
        self.sha512 = sha512
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        offset = try container.decode(Int64.self, forKey: .offset)
        size = try container.decode(Int64.self, forKey: .size)
        sha512 = try container.decode(String.self, forKey: .sha512)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(offset, forKey: .offset)
        try container.encode(size, forKey: .size)
        try container.encode(sha512, forKey: .sha512)
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
