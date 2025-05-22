import Foundation

public class LegalHoldPolicyAssignmentCountsField: Codable {
    private enum CodingKeys: String, CodingKey {
        case user
        case folder
        case file
        case fileVersion = "file_version"
    }

    /// The number of users this policy is applied to
    public let user: Int64?

    /// The number of folders this policy is applied to
    public let folder: Int64?

    /// The number of files this policy is applied to
    public let file: Int64?

    /// The number of file versions this policy is applied to
    public let fileVersion: Int64?

    /// Initializer for a LegalHoldPolicyAssignmentCountsField.
    ///
    /// - Parameters:
    ///   - user: The number of users this policy is applied to
    ///   - folder: The number of folders this policy is applied to
    ///   - file: The number of files this policy is applied to
    ///   - fileVersion: The number of file versions this policy is applied to
    public init(user: Int64? = nil, folder: Int64? = nil, file: Int64? = nil, fileVersion: Int64? = nil) {
        self.user = user
        self.folder = folder
        self.file = file
        self.fileVersion = fileVersion
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        user = try container.decodeIfPresent(Int64.self, forKey: .user)
        folder = try container.decodeIfPresent(Int64.self, forKey: .folder)
        file = try container.decodeIfPresent(Int64.self, forKey: .file)
        fileVersion = try container.decodeIfPresent(Int64.self, forKey: .fileVersion)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(user, forKey: .user)
        try container.encodeIfPresent(folder, forKey: .folder)
        try container.encodeIfPresent(file, forKey: .file)
        try container.encodeIfPresent(fileVersion, forKey: .fileVersion)
    }

}
