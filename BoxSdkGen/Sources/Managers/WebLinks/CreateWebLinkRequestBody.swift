import Foundation

public class CreateWebLinkRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case url
        case parent
        case name
        case description
    }

    /// The URL that this web link links to. Must start with
    /// `"http://"` or `"https://"`.
    public let url: String

    /// The parent folder to create the web link within.
    public let parent: CreateWebLinkRequestBodyParentField

    /// Name of the web link. Defaults to the URL if not set.
    public let name: String?

    /// Description of the web link.
    public let description: String?

    /// Initializer for a CreateWebLinkRequestBody.
    ///
    /// - Parameters:
    ///   - url: The URL that this web link links to. Must start with
    ///     `"http://"` or `"https://"`.
    ///   - parent: The parent folder to create the web link within.
    ///   - name: Name of the web link. Defaults to the URL if not set.
    ///   - description: Description of the web link.
    public init(url: String, parent: CreateWebLinkRequestBodyParentField, name: String? = nil, description: String? = nil) {
        self.url = url
        self.parent = parent
        self.name = name
        self.description = description
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(String.self, forKey: .url)
        parent = try container.decode(CreateWebLinkRequestBodyParentField.self, forKey: .parent)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(url, forKey: .url)
        try container.encode(parent, forKey: .parent)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
    }

}
