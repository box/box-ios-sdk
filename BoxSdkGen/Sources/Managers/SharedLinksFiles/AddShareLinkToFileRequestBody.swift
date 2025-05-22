import Foundation

public class AddShareLinkToFileRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case sharedLink = "shared_link"
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

}
