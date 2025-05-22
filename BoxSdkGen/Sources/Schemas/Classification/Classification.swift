import Foundation

/// An instance of the classification metadata template, containing
/// the classification applied to the file or folder.
/// 
/// To get more details about the classification applied to an item,
/// request the classification metadata template.
public class Classification: Codable {
    private enum CodingKeys: String, CodingKey {
        case boxSecurityClassificationKey = "Box__Security__Classification__Key"
        case parent = "$parent"
        case template = "$template"
        case scope = "$scope"
        case version = "$version"
        case type = "$type"
        case typeVersion = "$typeVersion"
        case canEdit = "$canEdit"
    }

    /// The name of the classification applied to the item.
    public let boxSecurityClassificationKey: String?

    /// The identifier of the item that this metadata instance
    /// has been attached to. This combines the `type` and the `id`
    /// of the parent in the form `{type}_{id}`.
    public let parent: String?

    /// `securityClassification-6VMVochwUWo`
    public let template: ClassificationTemplateField?

    /// The scope of the enterprise that this classification has been
    /// applied for.
    /// 
    /// This will be in the format `enterprise_{enterprise_id}`.
    public let scope: String?

    /// The version of the metadata instance. This version starts at 0 and
    /// increases every time a classification is updated.
    public let version: Int64?

    /// The unique ID of this classification instance. This will be include
    /// the name of the classification template and a unique ID.
    public let type: String?

    /// The version of the metadata template. This version starts at 0 and
    /// increases every time the template is updated. This is mostly for internal
    /// use.
    public let typeVersion: Double?

    /// Whether an end user can change the classification.
    public let canEdit: Bool?

    /// Initializer for a Classification.
    ///
    /// - Parameters:
    ///   - boxSecurityClassificationKey: The name of the classification applied to the item.
    ///   - parent: The identifier of the item that this metadata instance
    ///     has been attached to. This combines the `type` and the `id`
    ///     of the parent in the form `{type}_{id}`.
    ///   - template: `securityClassification-6VMVochwUWo`
    ///   - scope: The scope of the enterprise that this classification has been
    ///     applied for.
    ///     
    ///     This will be in the format `enterprise_{enterprise_id}`.
    ///   - version: The version of the metadata instance. This version starts at 0 and
    ///     increases every time a classification is updated.
    ///   - type: The unique ID of this classification instance. This will be include
    ///     the name of the classification template and a unique ID.
    ///   - typeVersion: The version of the metadata template. This version starts at 0 and
    ///     increases every time the template is updated. This is mostly for internal
    ///     use.
    ///   - canEdit: Whether an end user can change the classification.
    public init(boxSecurityClassificationKey: String? = nil, parent: String? = nil, template: ClassificationTemplateField? = nil, scope: String? = nil, version: Int64? = nil, type: String? = nil, typeVersion: Double? = nil, canEdit: Bool? = nil) {
        self.boxSecurityClassificationKey = boxSecurityClassificationKey
        self.parent = parent
        self.template = template
        self.scope = scope
        self.version = version
        self.type = type
        self.typeVersion = typeVersion
        self.canEdit = canEdit
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        boxSecurityClassificationKey = try container.decodeIfPresent(String.self, forKey: .boxSecurityClassificationKey)
        parent = try container.decodeIfPresent(String.self, forKey: .parent)
        template = try container.decodeIfPresent(ClassificationTemplateField.self, forKey: .template)
        scope = try container.decodeIfPresent(String.self, forKey: .scope)
        version = try container.decodeIfPresent(Int64.self, forKey: .version)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        typeVersion = try container.decodeIfPresent(Double.self, forKey: .typeVersion)
        canEdit = try container.decodeIfPresent(Bool.self, forKey: .canEdit)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(boxSecurityClassificationKey, forKey: .boxSecurityClassificationKey)
        try container.encodeIfPresent(parent, forKey: .parent)
        try container.encodeIfPresent(template, forKey: .template)
        try container.encodeIfPresent(scope, forKey: .scope)
        try container.encodeIfPresent(version, forKey: .version)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(typeVersion, forKey: .typeVersion)
        try container.encodeIfPresent(canEdit, forKey: .canEdit)
    }

}
