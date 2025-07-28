import Foundation

public class FileFullRepresentationsEntriesInfoField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case url
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The API URL that can be used to get more info on this file
    /// representation. Make sure to make an authenticated API call
    /// to this endpoint.
    public let url: String?

    /// Initializer for a FileFullRepresentationsEntriesInfoField.
    ///
    /// - Parameters:
    ///   - url: The API URL that can be used to get more info on this file
    ///     representation. Make sure to make an authenticated API call
    ///     to this endpoint.
    public init(url: String? = nil) {
        self.url = url
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decodeIfPresent(String.self, forKey: .url)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(url, forKey: .url)
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
