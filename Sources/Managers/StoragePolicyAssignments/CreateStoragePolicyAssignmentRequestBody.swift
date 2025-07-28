import Foundation

public class CreateStoragePolicyAssignmentRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case storagePolicy = "storage_policy"
        case assignedTo = "assigned_to"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The storage policy to assign to the user or
    /// enterprise.
    public let storagePolicy: CreateStoragePolicyAssignmentRequestBodyStoragePolicyField

    /// The user or enterprise to assign the storage
    /// policy to.
    public let assignedTo: CreateStoragePolicyAssignmentRequestBodyAssignedToField

    /// Initializer for a CreateStoragePolicyAssignmentRequestBody.
    ///
    /// - Parameters:
    ///   - storagePolicy: The storage policy to assign to the user or
    ///     enterprise.
    ///   - assignedTo: The user or enterprise to assign the storage
    ///     policy to.
    public init(storagePolicy: CreateStoragePolicyAssignmentRequestBodyStoragePolicyField, assignedTo: CreateStoragePolicyAssignmentRequestBodyAssignedToField) {
        self.storagePolicy = storagePolicy
        self.assignedTo = assignedTo
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        storagePolicy = try container.decode(CreateStoragePolicyAssignmentRequestBodyStoragePolicyField.self, forKey: .storagePolicy)
        assignedTo = try container.decode(CreateStoragePolicyAssignmentRequestBodyAssignedToField.self, forKey: .assignedTo)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(storagePolicy, forKey: .storagePolicy)
        try container.encode(assignedTo, forKey: .assignedTo)
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
