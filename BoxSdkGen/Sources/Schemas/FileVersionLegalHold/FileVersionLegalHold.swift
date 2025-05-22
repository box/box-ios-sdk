import Foundation

/// File version legal hold is an entity representing all
/// holds on a File Version.
public class FileVersionLegalHold: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case fileVersion = "file_version"
        case file
        case legalHoldPolicyAssignments = "legal_hold_policy_assignments"
        case deletedAt = "deleted_at"
    }

    /// The unique identifier for this file version legal hold
    public let id: String?

    /// `file_version_legal_hold`
    public let type: FileVersionLegalHoldTypeField?

    public let fileVersion: FileVersionMini?

    public let file: FileMini?

    /// List of assignments contributing to this Hold.
    public let legalHoldPolicyAssignments: [LegalHoldPolicyAssignment]?

    /// Time that this File-Version-Legal-Hold was
    /// deleted.
    public let deletedAt: Date?

    /// Initializer for a FileVersionLegalHold.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this file version legal hold
    ///   - type: `file_version_legal_hold`
    ///   - fileVersion: 
    ///   - file: 
    ///   - legalHoldPolicyAssignments: List of assignments contributing to this Hold.
    ///   - deletedAt: Time that this File-Version-Legal-Hold was
    ///     deleted.
    public init(id: String? = nil, type: FileVersionLegalHoldTypeField? = nil, fileVersion: FileVersionMini? = nil, file: FileMini? = nil, legalHoldPolicyAssignments: [LegalHoldPolicyAssignment]? = nil, deletedAt: Date? = nil) {
        self.id = id
        self.type = type
        self.fileVersion = fileVersion
        self.file = file
        self.legalHoldPolicyAssignments = legalHoldPolicyAssignments
        self.deletedAt = deletedAt
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(FileVersionLegalHoldTypeField.self, forKey: .type)
        fileVersion = try container.decodeIfPresent(FileVersionMini.self, forKey: .fileVersion)
        file = try container.decodeIfPresent(FileMini.self, forKey: .file)
        legalHoldPolicyAssignments = try container.decodeIfPresent([LegalHoldPolicyAssignment].self, forKey: .legalHoldPolicyAssignments)
        deletedAt = try container.decodeDateTimeIfPresent(forKey: .deletedAt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(fileVersion, forKey: .fileVersion)
        try container.encodeIfPresent(file, forKey: .file)
        try container.encodeIfPresent(legalHoldPolicyAssignments, forKey: .legalHoldPolicyAssignments)
        try container.encodeDateTimeIfPresent(field: deletedAt, forKey: .deletedAt)
    }

}
