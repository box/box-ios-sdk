import Foundation

/// The collaboration permissions.
public class CollaborationPermissionsV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case isCoOwnerRoleEnabled = "is_co_owner_role_enabled"
        case isEditorRoleEnabled = "is_editor_role_enabled"
        case isPreviewerRoleEnabled = "is_previewer_role_enabled"
        case isPreviewerUploaderRoleEnabled = "is_previewer_uploader_role_enabled"
        case isUploaderRoleEnabled = "is_uploader_role_enabled"
        case isViewerRoleEnabled = "is_viewer_role_enabled"
        case isViewerUploaderRoleEnabled = "is_viewer_uploader_role_enabled"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The co-owner role is enabled for collaboration.
    public let isCoOwnerRoleEnabled: Bool?

    /// The editor role is enabled for collaboration.
    public let isEditorRoleEnabled: Bool?

    /// The previewer role is enabled for collaboration.
    public let isPreviewerRoleEnabled: Bool?

    /// The previewer uploader role is enabled for collaboration.
    public let isPreviewerUploaderRoleEnabled: Bool?

    /// The uploader role is enabled for collaboration.
    public let isUploaderRoleEnabled: Bool?

    /// The viewer role is enabled for collaboration.
    public let isViewerRoleEnabled: Bool?

    /// The viewer uploader role is enabled for collaboration.
    public let isViewerUploaderRoleEnabled: Bool?

    /// Initializer for a CollaborationPermissionsV2025R0.
    ///
    /// - Parameters:
    ///   - isCoOwnerRoleEnabled: The co-owner role is enabled for collaboration.
    ///   - isEditorRoleEnabled: The editor role is enabled for collaboration.
    ///   - isPreviewerRoleEnabled: The previewer role is enabled for collaboration.
    ///   - isPreviewerUploaderRoleEnabled: The previewer uploader role is enabled for collaboration.
    ///   - isUploaderRoleEnabled: The uploader role is enabled for collaboration.
    ///   - isViewerRoleEnabled: The viewer role is enabled for collaboration.
    ///   - isViewerUploaderRoleEnabled: The viewer uploader role is enabled for collaboration.
    public init(isCoOwnerRoleEnabled: Bool? = nil, isEditorRoleEnabled: Bool? = nil, isPreviewerRoleEnabled: Bool? = nil, isPreviewerUploaderRoleEnabled: Bool? = nil, isUploaderRoleEnabled: Bool? = nil, isViewerRoleEnabled: Bool? = nil, isViewerUploaderRoleEnabled: Bool? = nil) {
        self.isCoOwnerRoleEnabled = isCoOwnerRoleEnabled
        self.isEditorRoleEnabled = isEditorRoleEnabled
        self.isPreviewerRoleEnabled = isPreviewerRoleEnabled
        self.isPreviewerUploaderRoleEnabled = isPreviewerUploaderRoleEnabled
        self.isUploaderRoleEnabled = isUploaderRoleEnabled
        self.isViewerRoleEnabled = isViewerRoleEnabled
        self.isViewerUploaderRoleEnabled = isViewerUploaderRoleEnabled
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isCoOwnerRoleEnabled = try container.decodeIfPresent(Bool.self, forKey: .isCoOwnerRoleEnabled)
        isEditorRoleEnabled = try container.decodeIfPresent(Bool.self, forKey: .isEditorRoleEnabled)
        isPreviewerRoleEnabled = try container.decodeIfPresent(Bool.self, forKey: .isPreviewerRoleEnabled)
        isPreviewerUploaderRoleEnabled = try container.decodeIfPresent(Bool.self, forKey: .isPreviewerUploaderRoleEnabled)
        isUploaderRoleEnabled = try container.decodeIfPresent(Bool.self, forKey: .isUploaderRoleEnabled)
        isViewerRoleEnabled = try container.decodeIfPresent(Bool.self, forKey: .isViewerRoleEnabled)
        isViewerUploaderRoleEnabled = try container.decodeIfPresent(Bool.self, forKey: .isViewerUploaderRoleEnabled)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(isCoOwnerRoleEnabled, forKey: .isCoOwnerRoleEnabled)
        try container.encodeIfPresent(isEditorRoleEnabled, forKey: .isEditorRoleEnabled)
        try container.encodeIfPresent(isPreviewerRoleEnabled, forKey: .isPreviewerRoleEnabled)
        try container.encodeIfPresent(isPreviewerUploaderRoleEnabled, forKey: .isPreviewerUploaderRoleEnabled)
        try container.encodeIfPresent(isUploaderRoleEnabled, forKey: .isUploaderRoleEnabled)
        try container.encodeIfPresent(isViewerRoleEnabled, forKey: .isViewerRoleEnabled)
        try container.encodeIfPresent(isViewerUploaderRoleEnabled, forKey: .isViewerUploaderRoleEnabled)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
