import Foundation

/// The assignment of a storage policy to a user or enterprise.
public class StoragePolicyAssignment: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case storagePolicy = "storage_policy"
        case assignedTo = "assigned_to"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The unique identifier for a storage policy assignment.
    public let id: String

    /// The value will always be `storage_policy_assignment`.
    public let type: StoragePolicyAssignmentTypeField

    public let storagePolicy: StoragePolicyMini?

    public let assignedTo: StoragePolicyAssignmentAssignedToField?

    /// Initializer for a StoragePolicyAssignment.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for a storage policy assignment.
    ///   - type: The value will always be `storage_policy_assignment`.
    ///   - storagePolicy: 
    ///   - assignedTo: 
    public init(id: String, type: StoragePolicyAssignmentTypeField = StoragePolicyAssignmentTypeField.storagePolicyAssignment, storagePolicy: StoragePolicyMini? = nil, assignedTo: StoragePolicyAssignmentAssignedToField? = nil) {
        self.id = id
        self.type = type
        self.storagePolicy = storagePolicy
        self.assignedTo = assignedTo
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(StoragePolicyAssignmentTypeField.self, forKey: .type)
        storagePolicy = try container.decodeIfPresent(StoragePolicyMini.self, forKey: .storagePolicy)
        assignedTo = try container.decodeIfPresent(StoragePolicyAssignmentAssignedToField.self, forKey: .assignedTo)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(storagePolicy, forKey: .storagePolicy)
        try container.encodeIfPresent(assignedTo, forKey: .assignedTo)
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
