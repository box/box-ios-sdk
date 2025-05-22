import Foundation

public class UpdateSharedLinkOnWebLinkRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case sharedLink = "shared_link"
    }

    /// The settings for the shared link to update.
    public let sharedLink: UpdateSharedLinkOnWebLinkRequestBodySharedLinkField?

    /// Initializer for a UpdateSharedLinkOnWebLinkRequestBody.
    ///
    /// - Parameters:
    ///   - sharedLink: The settings for the shared link to update.
    public init(sharedLink: UpdateSharedLinkOnWebLinkRequestBodySharedLinkField? = nil) {
        self.sharedLink = sharedLink
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sharedLink = try container.decodeIfPresent(UpdateSharedLinkOnWebLinkRequestBodySharedLinkField.self, forKey: .sharedLink)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(sharedLink, forKey: .sharedLink)
    }

}
