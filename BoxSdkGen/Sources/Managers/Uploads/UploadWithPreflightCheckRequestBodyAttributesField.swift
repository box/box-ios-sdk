import Foundation

public class UploadWithPreflightCheckRequestBodyAttributesField: Codable {
    private enum CodingKeys: String, CodingKey {
        case name
        case parent
        case size
        case contentCreatedAt = "content_created_at"
        case contentModifiedAt = "content_modified_at"
    }

    /// The name of the file
    public let name: String

    /// The parent folder to upload the file to
    public let parent: UploadWithPreflightCheckRequestBodyAttributesParentField

    /// The size of the file in bytes
    public let size: Int

    /// Defines the time the file was originally created at.
    /// 
    /// If not set, the upload time will be used.
    public let contentCreatedAt: Date?

    /// Defines the time the file was last modified at.
    /// 
    /// If not set, the upload time will be used.
    public let contentModifiedAt: Date?

    /// Initializer for a UploadWithPreflightCheckRequestBodyAttributesField.
    ///
    /// - Parameters:
    ///   - name: The name of the file
    ///   - parent: The parent folder to upload the file to
    ///   - size: The size of the file in bytes
    ///   - contentCreatedAt: Defines the time the file was originally created at.
    ///     
    ///     If not set, the upload time will be used.
    ///   - contentModifiedAt: Defines the time the file was last modified at.
    ///     
    ///     If not set, the upload time will be used.
    public init(name: String, parent: UploadWithPreflightCheckRequestBodyAttributesParentField, size: Int, contentCreatedAt: Date? = nil, contentModifiedAt: Date? = nil) {
        self.name = name
        self.parent = parent
        self.size = size
        self.contentCreatedAt = contentCreatedAt
        self.contentModifiedAt = contentModifiedAt
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        parent = try container.decode(UploadWithPreflightCheckRequestBodyAttributesParentField.self, forKey: .parent)
        size = try container.decode(Int.self, forKey: .size)
        contentCreatedAt = try container.decodeDateTimeIfPresent(forKey: .contentCreatedAt)
        contentModifiedAt = try container.decodeDateTimeIfPresent(forKey: .contentModifiedAt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(parent, forKey: .parent)
        try container.encode(size, forKey: .size)
        try container.encodeDateTimeIfPresent(field: contentCreatedAt, forKey: .contentCreatedAt)
        try container.encodeDateTimeIfPresent(field: contentModifiedAt, forKey: .contentModifiedAt)
    }

}
