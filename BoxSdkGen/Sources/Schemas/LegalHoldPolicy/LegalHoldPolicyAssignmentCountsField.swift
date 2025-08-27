import Foundation

public class LegalHoldPolicyAssignmentCountsField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case user
        case folder
        case file
        case fileVersion = "file_version"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The number of users this policy is applied to.
    public let user: Int64?

    /// The number of folders this policy is applied to.
    public let folder: Int64?

    /// The number of files this policy is applied to.
    public let file: Int64?

    /// The number of file versions this policy is applied to.
    public let fileVersion: Int64?

    /// Initializer for a LegalHoldPolicyAssignmentCountsField.
    ///
    /// - Parameters:
    ///   - user: The number of users this policy is applied to.
    ///   - folder: The number of folders this policy is applied to.
    ///   - file: The number of files this policy is applied to.
    ///   - fileVersion: The number of file versions this policy is applied to.
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
