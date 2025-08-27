import Foundation

public class AddShareLinkToFileRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case sharedLink = "shared_link"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The settings for the shared link to create on the file.
    /// Use an empty object (`{}`) to use the default settings for shared
    /// links.
    public let sharedLink: AddShareLinkToFileRequestBodySharedLinkField?

    /// Initializer for a AddShareLinkToFileRequestBody.
    ///
    /// - Parameters:
    ///   - sharedLink: The settings for the shared link to create on the file.
    ///     Use an empty object (`{}`) to use the default settings for shared
    ///     links.
    public init(sharedLink: AddShareLinkToFileRequestBodySharedLinkField? = nil) {
        self.sharedLink = sharedLink
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sharedLink = try container.decodeIfPresent(AddShareLinkToFileRequestBodySharedLinkField.self, forKey: .sharedLink)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(sharedLink, forKey: .sharedLink)
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
