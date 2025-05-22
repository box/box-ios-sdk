import Foundation

public class AddShareLinkToFolderRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case sharedLink = "shared_link"
    }

    /// The settings for the shared link to create on the folder.
    /// 
    /// Use an empty object (`{}`) to use the default settings for shared
    /// links.
    public let sharedLink: AddShareLinkToFolderRequestBodySharedLinkField?

    /// Initializer for a AddShareLinkToFolderRequestBody.
    ///
    /// - Parameters:
    ///   - sharedLink: The settings for the shared link to create on the folder.
    ///     
    ///     Use an empty object (`{}`) to use the default settings for shared
    ///     links.
    public init(sharedLink: AddShareLinkToFolderRequestBodySharedLinkField? = nil) {
        self.sharedLink = sharedLink
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sharedLink = try container.decodeIfPresent(AddShareLinkToFolderRequestBodySharedLinkField.self, forKey: .sharedLink)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(sharedLink, forKey: .sharedLink)
    }

}
