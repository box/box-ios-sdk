import Foundation

public class CreateFolderLockRequestBodyFolderField: Codable {
    private enum CodingKeys: String, CodingKey {
        case type
        case id
    }

    /// The content type the lock is being applied to. Only `folder`
    /// is supported.
    public let type: String

    /// The ID of the folder.
    public let id: String

    /// Initializer for a CreateFolderLockRequestBodyFolderField.
    ///
    /// - Parameters:
    ///   - type: The content type the lock is being applied to. Only `folder`
    ///     is supported.
    ///   - id: The ID of the folder.
    public init(type: String, id: String) {
        self.type = type
        self.id = id
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        id = try container.decode(String.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(id, forKey: .id)
    }

}
