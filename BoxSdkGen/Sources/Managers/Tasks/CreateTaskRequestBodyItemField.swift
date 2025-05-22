import Foundation

public class CreateTaskRequestBodyItemField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
    }

    /// The ID of the file
    public let id: String?

    /// `file`
    public let type: CreateTaskRequestBodyItemTypeField?

    /// Initializer for a CreateTaskRequestBodyItemField.
    ///
    /// - Parameters:
    ///   - id: The ID of the file
    ///   - type: `file`
    public init(id: String? = nil, type: CreateTaskRequestBodyItemTypeField? = nil) {
        self.id = id
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        type = try container.decodeIfPresent(CreateTaskRequestBodyItemTypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(type, forKey: .type)
    }

}
