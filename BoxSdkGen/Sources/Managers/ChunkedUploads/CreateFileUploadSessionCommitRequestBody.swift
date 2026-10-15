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
    /// 
    /// Each entry can include `sha1` or `sha512`. Include `sha512`
    /// on every entry or on none of them. A request where only
    /// some entries include `sha512` is rejected.
    /// 
    /// Include parts that the server already has, returned as
    /// `hits` by the [`Plan upload session`](https://developer.box.com/reference/post-files-upload-sessions-id-plan)
    /// endpoint. Use the `part_id`, `offset`, and `size` from the
    /// plan response. If the other entries include `sha512`,
    /// include the `sha512` value from the plan response.
    /// Otherwise, leave the hash out of these entries.
    public let parts: [UploadPart]

    /// Initializer for a CreateFileUploadSessionCommitRequestBody.
    ///
    /// - Parameters:
    ///   - parts: The list details for the uploaded parts.
    ///     
    ///     Each entry can include `sha1` or `sha512`. Include `sha512`
    ///     on every entry or on none of them. A request where only
    ///     some entries include `sha512` is rejected.
    ///     
    ///     Include parts that the server already has, returned as
    ///     `hits` by the [`Plan upload session`](https://developer.box.com/reference/post-files-upload-sessions-id-plan)
    ///     endpoint. Use the `part_id`, `offset`, and `size` from the
    ///     plan response. If the other entries include `sha512`,
    ///     include the `sha512` value from the plan response.
    ///     Otherwise, leave the hash out of these entries.
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
