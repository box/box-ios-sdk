import Foundation

/// An instance of a metadata template, which has been applied to a file or
/// folder.
public class Metadata: MetadataBase {
    /// Initializer for a Metadata.
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
    public override init(parent: String? = nil, template: String? = nil, scope: String? = nil, version: Int64? = nil) {
        super.init(parent: parent, template: template, scope: scope, version: version)
    }

    required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

}
