import Foundation

/// The item that the legal hold policy is assigned to. Includes type and ID.
public class LegalHoldPolicyAssignedItem: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case type
        case id
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The type of item the policy is assigned to.
    public let type: LegalHoldPolicyAssignedItemTypeField

    /// The ID of the item the policy is assigned to.
    public let id: String

    /// Initializer for a LegalHoldPolicyAssignedItem.
    ///
    /// - Parameters:
    ///   - type: The type of item the policy is assigned to.
    ///   - id: The ID of the item the policy is assigned to.
    public init(type: LegalHoldPolicyAssignedItemTypeField, id: String) {
        self.type = type
        self.id = id
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(LegalHoldPolicyAssignedItemTypeField.self, forKey: .type)
        id = try container.decode(String.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(id, forKey: .id)
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
