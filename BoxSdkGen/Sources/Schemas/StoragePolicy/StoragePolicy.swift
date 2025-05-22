import Foundation

/// The Storage Policy object describes the storage zone.
public class StoragePolicy: StoragePolicyMini {
    private enum CodingKeys: String, CodingKey {
        case name
    }

    /// A descriptive name of the region
    public let name: String?

    /// Initializer for a StoragePolicy.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for this storage policy
    ///   - type: `storage_policy`
    ///   - name: A descriptive name of the region
    public init(id: String, type: StoragePolicyMiniTypeField = StoragePolicyMiniTypeField.storagePolicy, name: String? = nil) {
        self.name = name

        super.init(id: id, type: type)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try super.encode(to: encoder)
    }

}
