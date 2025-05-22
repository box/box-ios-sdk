import Foundation

/// A mini description of a Storage Policy object
public class StoragePolicyMini: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The unique identifier for this storage policy
    public let id: String

    /// `storage_policy`
    public let type: StoragePolicyMiniTypeField

    /// Initializer for a StoragePolicyMini.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this storage policy
    ///   - type: `storage_policy`
    public init(id: String, type: StoragePolicyMiniTypeField = StoragePolicyMiniTypeField.storagePolicy) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(StoragePolicyMiniTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
    }

}
