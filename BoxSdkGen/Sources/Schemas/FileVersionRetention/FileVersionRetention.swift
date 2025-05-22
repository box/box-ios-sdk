import Foundation

/// A retention policy blocks permanent deletion of content
/// for a specified amount of time. Admins can apply policies to
/// specified folders, or an entire enterprise. A file version retention
/// is a  record for a retained file version. To use this feature,
/// you must  have the manage retention policies scope enabled for your
/// API key in your application management console.
/// 
/// **Note**:
/// File retention API is now **deprecated**. 
/// To get information about files and file versions under retention,
/// see [files under retention](e://get-retention-policy-assignments-id-files-under-retention) or [file versions under retention](e://get-retention-policy-assignments-id-file-versions-under-retention) endpoints.
public class FileVersionRetention: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case fileVersion = "file_version"
        case file
        case appliedAt = "applied_at"
        case dispositionAt = "disposition_at"
        case winningRetentionPolicy = "winning_retention_policy"
    }

    /// The unique identifier for this file version retention.
    public let id: String?

    /// `file_version_retention`
    public let type: FileVersionRetentionTypeField?

    public let fileVersion: FileVersionMini?

    public let file: FileMini?

    /// When this file version retention object was
    /// created
    public let appliedAt: Date?

    /// When the retention expires on this file
    /// version retention
    public let dispositionAt: Date?

    public let winningRetentionPolicy: RetentionPolicyMini?

    /// Initializer for a FileVersionRetention.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this file version retention.
    ///   - type: `file_version_retention`
    ///   - fileVersion: 
    ///   - file: 
    ///   - appliedAt: When this file version retention object was
    ///     created
    ///   - dispositionAt: When the retention expires on this file
    ///     version retention
    ///   - winningRetentionPolicy: 
    public init(id: String? = nil, type: FileVersionRetentionTypeField? = nil, fileVersion: FileVersionMini? = nil, file: FileMini? = nil, appliedAt: Date? = nil, dispositionAt: Date? = nil, winningRetentionPolicy: RetentionPolicyMini? = nil) {
        self.id = id
        self.type = type
        self.fileVersion = fileVersion
        self.file = file
        self.appliedAt = appliedAt
        self.dispositionAt = dispositionAt
        self.winningRetentionPolicy = winningRetentionPolicy
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(FileVersionRetentionTypeField.self, forKey: .type)
        fileVersion = try container.decodeIfPresent(FileVersionMini.self, forKey: .fileVersion)
        file = try container.decodeIfPresent(FileMini.self, forKey: .file)
        appliedAt = try container.decodeDateTimeIfPresent(forKey: .appliedAt)
        dispositionAt = try container.decodeDateTimeIfPresent(forKey: .dispositionAt)
        winningRetentionPolicy = try container.decodeIfPresent(RetentionPolicyMini.self, forKey: .winningRetentionPolicy)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(fileVersion, forKey: .fileVersion)
        try container.encodeIfPresent(file, forKey: .file)
        try container.encodeDateTimeIfPresent(field: appliedAt, forKey: .appliedAt)
        try container.encodeDateTimeIfPresent(field: dispositionAt, forKey: .dispositionAt)
        try container.encodeIfPresent(winningRetentionPolicy, forKey: .winningRetentionPolicy)
    }

}
