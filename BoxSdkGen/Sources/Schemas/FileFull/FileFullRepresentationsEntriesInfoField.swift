import Foundation

public class FileFullRepresentationsEntriesInfoField: Codable {
    private enum CodingKeys: String, CodingKey {
        case url
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

}
