import Foundation

/// An instance of a metadata template, which has been applied to a file or
/// folder.
public class MetadataFull: Metadata {
    private struct CodingKeys: CodingKey {
        static let canEdit = CodingKeys(stringValue: "$canEdit")
        static let id = CodingKeys(stringValue: "$id")
        static let type = CodingKeys(stringValue: "$type")
        static let typeVersion = CodingKeys(stringValue: "$typeVersion")

        var intValue: Int?

        var stringValue: String

        init?(intValue: Int) {
            return nil
        }

        init(stringValue: String) {
            self.stringValue = stringValue
        }

    }

    /// Whether the user can edit this metadata instance.
    public let canEdit: Bool?

    /// A UUID to identify the metadata instance.
    public let id: String?

    /// A unique identifier for the "type" of this instance. This is an
    /// internal system property and should not be used by a client
    /// application.
    public let type: String?

    /// The last-known version of the template of the object. This is an
    /// internal system property and should not be used by a client
    /// application.
    public let typeVersion: Int64?

    public let extraData: [String: AnyCodable]?

    /// Initializer for a MetadataFull.
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
    ///   - canEdit: Whether the user can edit this metadata instance.
    ///   - id: A UUID to identify the metadata instance.
    ///   - type: A unique identifier for the "type" of this instance. This is an
    ///     internal system property and should not be used by a client
    ///     application.
    ///   - typeVersion: The last-known version of the template of the object. This is an
    ///     internal system property and should not be used by a client
    ///     application.
    ///   - extraData: 
    public init(parent: String? = nil, template: String? = nil, scope: String? = nil, version: Int64? = nil, canEdit: Bool? = nil, id: String? = nil, type: String? = nil, typeVersion: Int64? = nil, extraData: [String: AnyCodable]? = nil) {
        self.canEdit = canEdit
        self.id = id
        self.type = type
        self.typeVersion = typeVersion
        self.extraData = extraData

        super.init(parent: parent, template: template, scope: scope, version: version)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        canEdit = try container.decodeIfPresent(Bool.self, forKey: .canEdit)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        typeVersion = try container.decodeIfPresent(Int64.self, forKey: .typeVersion)

        let allKeys: [CodingKeys] = container.allKeys
        let definedKeys: [CodingKeys] = [.canEdit, .id, .type, .typeVersion]
        let additionalKeys: [CodingKeys] = allKeys.filter({ (parent: CodingKeys) in !definedKeys.contains(where: { (child: CodingKeys) in child.stringValue == parent.stringValue }) })

        if !additionalKeys.isEmpty {
            var additionalProperties: [String: AnyCodable] = [:]
            for key in additionalKeys {
                if let value = try? container.decode(AnyCodable.self, forKey: key) {
                    additionalProperties[key.stringValue] = value
                }

            }

            extraData = additionalProperties
        } else {
            extraData = nil
        }


        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(canEdit, forKey: .canEdit)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(typeVersion, forKey: .typeVersion)

        if let extraData = extraData {
            for (key,value) in extraData {
                try container.encodeIfPresent(value, forKey: CodingKeys(stringValue: key))
            }

        }

        try super.encode(to: encoder)
    }

}
