import Foundation

public class CreateRetentionPolicyAssignmentRequestBodyAssignToField: Codable, RawJSONReadable {
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


    /// The type of item to assign the policy to.
    public let type: CreateRetentionPolicyAssignmentRequestBodyAssignToTypeField

    /// The ID of item to assign the policy to.
    /// Set to `null` or omit when `type` is set to
    /// `enterprise`.
    @CodableTriState public private(set) var id: String?

    /// Initializer for a CreateRetentionPolicyAssignmentRequestBodyAssignToField.
    ///
    /// - Parameters:
    ///   - type: The type of item to assign the policy to.
    ///   - id: The ID of item to assign the policy to.
    ///     Set to `null` or omit when `type` is set to
    ///     `enterprise`.
    public init(type: CreateRetentionPolicyAssignmentRequestBodyAssignToTypeField, id: TriStateField<String> = nil) {
        self.type = type
        self._id = CodableTriState(state: id)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(CreateRetentionPolicyAssignmentRequestBodyAssignToTypeField.self, forKey: .type)
        id = try container.decodeIfPresent(String.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(field: _id.state, forKey: .id)
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
