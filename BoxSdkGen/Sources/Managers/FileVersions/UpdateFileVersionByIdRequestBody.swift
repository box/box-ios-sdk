import Foundation

public class UpdateFileVersionByIdRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case trashedAt = "trashed_at"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Set this to `null` to clear
    /// the date and restore the file.
    @CodableTriState public private(set) var trashedAt: String?

    /// Initializer for a UpdateFileVersionByIdRequestBody.
    ///
    /// - Parameters:
    ///   - trashedAt: Set this to `null` to clear
    ///     the date and restore the file.
    public init(trashedAt: TriStateField<String> = nil) {
        self._trashedAt = CodableTriState(state: trashedAt)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        trashedAt = try container.decodeIfPresent(String.self, forKey: .trashedAt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(field: _trashedAt.state, forKey: .trashedAt)
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
