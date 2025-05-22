import Foundation

/// The base representation of a metadata instance.
public class MetadataBase: Codable {
    private enum CodingKeys: String, CodingKey {
        case parent = "$parent"
        case template = "$template"
        case scope = "$scope"
        case version = "$version"
    }

    /// The identifier of the item that this metadata instance
    /// has been attached to. This combines the `type` and the `id`
    /// of the parent in the form `{type}_{id}`.
    public let parent: String?

    /// The name of the template
    public let template: String?

    /// An ID for the scope in which this template
    /// has been applied. This will be `enterprise_{enterprise_id}` for templates
    /// defined for use in this enterprise, and `global` for general templates
    /// that are available to all enterprises using Box.
    public let scope: String?

    /// The version of the metadata instance. This version starts at 0 and
    /// increases every time a user-defined property is modified.
    public let version: Int64?

    /// Initializer for a MetadataBase.
    ///
    /// - Parameters:
    ///   - parent: The identifier of the item that this metadata instance
    ///     has been attached to. This combines the `type` and the `id`
    ///     of the parent in the form `{type}_{id}`.
    ///   - template: The name of the template
    ///   - scope: An ID for the scope in which this template
    ///     has been applied. This will be `enterprise_{enterprise_id}` for templates
    ///     defined for use in this enterprise, and `global` for general templates
    ///     that are available to all enterprises using Box.
    ///   - version: The version of the metadata instance. This version starts at 0 and
    ///     increases every time a user-defined property is modified.
    public init(parent: String? = nil, template: String? = nil, scope: String? = nil, version: Int64? = nil) {
        self.parent = parent
        self.template = template
        self.scope = scope
        self.version = version
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        parent = try container.decodeIfPresent(String.self, forKey: .parent)
        template = try container.decodeIfPresent(String.self, forKey: .template)
        scope = try container.decodeIfPresent(String.self, forKey: .scope)
        version = try container.decodeIfPresent(Int64.self, forKey: .version)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(parent, forKey: .parent)
        try container.encodeIfPresent(template, forKey: .template)
        try container.encodeIfPresent(scope, forKey: .scope)
        try container.encodeIfPresent(version, forKey: .version)
    }

}
