import Foundation

public class UploadWithPreflightCheckRequestBodyAttributesParentField: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
    }

    /// The id of the parent folder. Use
    /// `0` for the user's root folder.
    public let id: String

    /// Initializer for a UploadWithPreflightCheckRequestBodyAttributesParentField.
    ///
    /// - Parameters:
    ///   - id: The id of the parent folder. Use
    ///     `0` for the user's root folder.
    public init(id: String) {
        self.id = id
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
    }

}
