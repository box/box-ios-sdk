import Foundation

public class UpdateFolderByIdRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case name
        case description
        case syncState = "sync_state"
        case canNonOwnersInvite = "can_non_owners_invite"
        case parent
        case sharedLink = "shared_link"
        case folderUploadEmail = "folder_upload_email"
        case tags
        case isCollaborationRestrictedToEnterprise = "is_collaboration_restricted_to_enterprise"
        case collections
        case canNonOwnersViewCollaborators = "can_non_owners_view_collaborators"
    }

    /// The optional new name for this folder.
    public let name: String?

    /// The optional description of this folder
    public let description: String?

    /// Specifies whether a folder should be synced to a
    /// user's device or not. This is used by Box Sync
    /// (discontinued) and is not used by Box Drive.
    public let syncState: UpdateFolderByIdRequestBodySyncStateField?

    /// Specifies if users who are not the owner
    /// of the folder can invite new collaborators to the folder.
    public let canNonOwnersInvite: Bool?

    public let parent: UpdateFolderByIdRequestBodyParentField?

    public let sharedLink: UpdateFolderByIdRequestBodySharedLinkField?

    @CodableTriState public private(set) var folderUploadEmail: UpdateFolderByIdRequestBodyFolderUploadEmailField?

    /// The tags for this item. These tags are shown in
    /// the Box web app and mobile apps next to an item.
    /// 
    /// To add or remove a tag, retrieve the item's current tags,
    /// modify them, and then update this field.
    /// 
    /// There is a limit of 100 tags per item, and 10,000
    /// unique tags per enterprise.
    public let tags: [String]?

    /// Specifies if new invites to this folder are restricted to users
    /// within the enterprise. This does not affect existing
    /// collaborations.
    public let isCollaborationRestrictedToEnterprise: Bool?

    /// An array of collections to make this folder
    /// a member of. Currently
    /// we only support the `favorites` collection.
    /// 
    /// To get the ID for a collection, use the
    /// [List all collections][1] endpoint.
    /// 
    /// Passing an empty array `[]` or `null` will remove
    /// the folder from all collections.
    /// 
    /// [1]: e://get-collections
    @CodableTriState public private(set) var collections: [UpdateFolderByIdRequestBodyCollectionsField]?

    /// Restricts collaborators who are not the owner of
    /// this folder from viewing other collaborations on
    /// this folder.
    /// 
    /// It also restricts non-owners from inviting new
    /// collaborators.
    /// 
    /// When setting this field to `false`, it is required
    /// to also set `can_non_owners_invite_collaborators` to
    /// `false` if it has not already been set.
    public let canNonOwnersViewCollaborators: Bool?

    /// Initializer for a UpdateFolderByIdRequestBody.
    ///
    /// - Parameters:
    ///   - name: The optional new name for this folder.
    ///   - description: The optional description of this folder
    ///   - syncState: Specifies whether a folder should be synced to a
    ///     user's device or not. This is used by Box Sync
    ///     (discontinued) and is not used by Box Drive.
    ///   - canNonOwnersInvite: Specifies if users who are not the owner
    ///     of the folder can invite new collaborators to the folder.
    ///   - parent: 
    ///   - sharedLink: 
    ///   - folderUploadEmail: 
    ///   - tags: The tags for this item. These tags are shown in
    ///     the Box web app and mobile apps next to an item.
    ///     
    ///     To add or remove a tag, retrieve the item's current tags,
    ///     modify them, and then update this field.
    ///     
    ///     There is a limit of 100 tags per item, and 10,000
    ///     unique tags per enterprise.
    ///   - isCollaborationRestrictedToEnterprise: Specifies if new invites to this folder are restricted to users
    ///     within the enterprise. This does not affect existing
    ///     collaborations.
    ///   - collections: An array of collections to make this folder
    ///     a member of. Currently
    ///     we only support the `favorites` collection.
    ///     
    ///     To get the ID for a collection, use the
    ///     [List all collections][1] endpoint.
    ///     
    ///     Passing an empty array `[]` or `null` will remove
    ///     the folder from all collections.
    ///     
    ///     [1]: e://get-collections
    ///   - canNonOwnersViewCollaborators: Restricts collaborators who are not the owner of
    ///     this folder from viewing other collaborations on
    ///     this folder.
    ///     
    ///     It also restricts non-owners from inviting new
    ///     collaborators.
    ///     
    ///     When setting this field to `false`, it is required
    ///     to also set `can_non_owners_invite_collaborators` to
    ///     `false` if it has not already been set.
    public init(name: String? = nil, description: String? = nil, syncState: UpdateFolderByIdRequestBodySyncStateField? = nil, canNonOwnersInvite: Bool? = nil, parent: UpdateFolderByIdRequestBodyParentField? = nil, sharedLink: UpdateFolderByIdRequestBodySharedLinkField? = nil, folderUploadEmail: TriStateField<UpdateFolderByIdRequestBodyFolderUploadEmailField> = nil, tags: [String]? = nil, isCollaborationRestrictedToEnterprise: Bool? = nil, collections: TriStateField<[UpdateFolderByIdRequestBodyCollectionsField]> = nil, canNonOwnersViewCollaborators: Bool? = nil) {
        self.name = name
        self.description = description
        self.syncState = syncState
        self.canNonOwnersInvite = canNonOwnersInvite
        self.parent = parent
        self.sharedLink = sharedLink
        self._folderUploadEmail = CodableTriState(state: folderUploadEmail)
        self.tags = tags
        self.isCollaborationRestrictedToEnterprise = isCollaborationRestrictedToEnterprise
        self._collections = CodableTriState(state: collections)
        self.canNonOwnersViewCollaborators = canNonOwnersViewCollaborators
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        syncState = try container.decodeIfPresent(UpdateFolderByIdRequestBodySyncStateField.self, forKey: .syncState)
        canNonOwnersInvite = try container.decodeIfPresent(Bool.self, forKey: .canNonOwnersInvite)
        parent = try container.decodeIfPresent(UpdateFolderByIdRequestBodyParentField.self, forKey: .parent)
        sharedLink = try container.decodeIfPresent(UpdateFolderByIdRequestBodySharedLinkField.self, forKey: .sharedLink)
        folderUploadEmail = try container.decodeIfPresent(UpdateFolderByIdRequestBodyFolderUploadEmailField.self, forKey: .folderUploadEmail)
        tags = try container.decodeIfPresent([String].self, forKey: .tags)
        isCollaborationRestrictedToEnterprise = try container.decodeIfPresent(Bool.self, forKey: .isCollaborationRestrictedToEnterprise)
        collections = try container.decodeIfPresent([UpdateFolderByIdRequestBodyCollectionsField].self, forKey: .collections)
        canNonOwnersViewCollaborators = try container.decodeIfPresent(Bool.self, forKey: .canNonOwnersViewCollaborators)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(syncState, forKey: .syncState)
        try container.encodeIfPresent(canNonOwnersInvite, forKey: .canNonOwnersInvite)
        try container.encodeIfPresent(parent, forKey: .parent)
        try container.encodeIfPresent(sharedLink, forKey: .sharedLink)
        try container.encode(field: _folderUploadEmail.state, forKey: .folderUploadEmail)
        try container.encodeIfPresent(tags, forKey: .tags)
        try container.encodeIfPresent(isCollaborationRestrictedToEnterprise, forKey: .isCollaborationRestrictedToEnterprise)
        try container.encode(field: _collections.state, forKey: .collections)
        try container.encodeIfPresent(canNonOwnersViewCollaborators, forKey: .canNonOwnersViewCollaborators)
    }

}
