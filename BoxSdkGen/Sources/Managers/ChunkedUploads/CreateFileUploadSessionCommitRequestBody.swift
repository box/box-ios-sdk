import Foundation

public class CreateFileUploadSessionCommitRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case parts
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The list details for the uploaded parts.
    public let parts: [UploadPart]

    /// Initializer for a CreateFileUploadSessionCommitRequestBody.
    ///
    /// - Parameters:
    ///   - parts: The list details for the uploaded parts.
    public init(parts: [UploadPart]) {
        self.parts = parts
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        parts = try container.decode([UploadPart].self, forKey: .parts)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(parts, forKey: .parts)
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
