import Foundation

public class CreateMetadataCascadePolicyRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case folderId = "folder_id"
        case scope
        case templateKey
    }

    /// The ID of the folder to apply the policy to. This folder will
    /// need to already have an instance of the targeted metadata
    /// template applied to it.
    public let folderId: String

    /// The scope of the targeted metadata template. This template will
    /// need to already have an instance applied to the targeted folder.
    public let scope: CreateMetadataCascadePolicyRequestBodyScopeField

    /// The key of the targeted metadata template. This template will
    /// need to already have an instance applied to the targeted folder.
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
    public let templateKey: String

    /// Initializer for a CreateMetadataCascadePolicyRequestBody.
    ///
    /// - Parameters:
    ///   - folderId: The ID of the folder to apply the policy to. This folder will
    ///     need to already have an instance of the targeted metadata
    ///     template applied to it.
    ///   - scope: The scope of the targeted metadata template. This template will
    ///     need to already have an instance applied to the targeted folder.
    ///   - templateKey: The key of the targeted metadata template. This template will
    ///     need to already have an instance applied to the targeted folder.
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
    public init(folderId: String, scope: CreateMetadataCascadePolicyRequestBodyScopeField, templateKey: String) {
        self.folderId = folderId
        self.scope = scope
        self.templateKey = templateKey
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        folderId = try container.decode(String.self, forKey: .folderId)
        scope = try container.decode(CreateMetadataCascadePolicyRequestBodyScopeField.self, forKey: .scope)
        templateKey = try container.decode(String.self, forKey: .templateKey)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(folderId, forKey: .folderId)
        try container.encode(scope, forKey: .scope)
        try container.encode(templateKey, forKey: .templateKey)
    }

}
