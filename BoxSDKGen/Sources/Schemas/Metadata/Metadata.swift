import Foundation

/// An instance of a metadata template, which has been applied to a file or
/// folder.
public class Metadata: MetadataBase {
    private enum CodingKeys: CodingKey {
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public override var rawData: [String: Any]? {
        return _rawData
    }


    /// Initializer for a Metadata.
    ///
    /// - Parameters:
    ///   - parent: The identifier of the item that this metadata instance
    ///     has been attached to. This combines the `type` and the `id`
    ///     of the parent in the form `{type}_{id}`.
    ///   - template: The name of the template.
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

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    override func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    override func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
