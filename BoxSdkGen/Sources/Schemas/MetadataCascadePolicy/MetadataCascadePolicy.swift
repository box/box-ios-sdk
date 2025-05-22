import Foundation

/// A metadata cascade policy automatically applies a metadata template instance
/// to all the files and folders within the targeted folder.
public class MetadataCascadePolicy: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case ownerEnterprise = "owner_enterprise"
        case parent
        case scope
        case templateKey
    }

    /// The ID of the metadata cascade policy object
    public let id: String

    /// `metadata_cascade_policy`
    public let type: MetadataCascadePolicyTypeField

    /// The enterprise that owns this policy.
    public let ownerEnterprise: MetadataCascadePolicyOwnerEnterpriseField?

    /// Represent the folder the policy is applied to.
    public let parent: MetadataCascadePolicyParentField?

    /// The scope of the metadata cascade policy can either be `global` or
    /// `enterprise_*`. The `global` scope is used for policies that are
    /// available to any Box enterprise. The `enterprise_*` scope represents
    /// policies that have been created within a specific enterprise, where `*`
    /// will be the ID of that enterprise.
    public let scope: String?

    /// The key of the template that is cascaded down to the folder's
    /// children.
    /// 
    /// In many cases the template key is automatically derived
    /// of its display name, for example `Contract Template` would
    /// become `contractTemplate`. In some cases the creator of the
    /// template will have provided its own template key.
    /// 
    /// Please [list the templates for an enterprise][list], or
    /// get all instances on a [file][file] or [folder][folder]
    /// to inspect a template's key.
    /// 
    /// [list]: e://get-metadata-templates-enterprise
    /// [file]: e://get-files-id-metadata
    /// [folder]: e://get-folders-id-metadata
    public let templateKey: String?

    /// Initializer for a MetadataCascadePolicy.
    ///
    /// - Parameters:
    ///   - id: The ID of the metadata cascade policy object
    ///   - type: `metadata_cascade_policy`
    ///   - ownerEnterprise: The enterprise that owns this policy.
    ///   - parent: Represent the folder the policy is applied to.
    ///   - scope: The scope of the metadata cascade policy can either be `global` or
    ///     `enterprise_*`. The `global` scope is used for policies that are
    ///     available to any Box enterprise. The `enterprise_*` scope represents
    ///     policies that have been created within a specific enterprise, where `*`
    ///     will be the ID of that enterprise.
    ///   - templateKey: The key of the template that is cascaded down to the folder's
    ///     children.
    ///     
    ///     In many cases the template key is automatically derived
    ///     of its display name, for example `Contract Template` would
    ///     become `contractTemplate`. In some cases the creator of the
    ///     template will have provided its own template key.
    ///     
    ///     Please [list the templates for an enterprise][list], or
    ///     get all instances on a [file][file] or [folder][folder]
    ///     to inspect a template's key.
    ///     
    ///     [list]: e://get-metadata-templates-enterprise
    ///     [file]: e://get-files-id-metadata
    ///     [folder]: e://get-folders-id-metadata
    public init(id: String, type: MetadataCascadePolicyTypeField = MetadataCascadePolicyTypeField.metadataCascadePolicy, ownerEnterprise: MetadataCascadePolicyOwnerEnterpriseField? = nil, parent: MetadataCascadePolicyParentField? = nil, scope: String? = nil, templateKey: String? = nil) {
        self.id = id
        self.type = type
        self.ownerEnterprise = ownerEnterprise
        self.parent = parent
        self.scope = scope
        self.templateKey = templateKey
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(MetadataCascadePolicyTypeField.self, forKey: .type)
        ownerEnterprise = try container.decodeIfPresent(MetadataCascadePolicyOwnerEnterpriseField.self, forKey: .ownerEnterprise)
        parent = try container.decodeIfPresent(MetadataCascadePolicyParentField.self, forKey: .parent)
        scope = try container.decodeIfPresent(String.self, forKey: .scope)
        templateKey = try container.decodeIfPresent(String.self, forKey: .templateKey)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(ownerEnterprise, forKey: .ownerEnterprise)
        try container.encodeIfPresent(parent, forKey: .parent)
        try container.encodeIfPresent(scope, forKey: .scope)
        try container.encodeIfPresent(templateKey, forKey: .templateKey)
    }

}
