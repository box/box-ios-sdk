import Foundation

public class CreateCollaborationWhitelistEntryRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case domain
        case direction
    }

    /// The domain to add to the list of allowed domains.
    public let domain: String

    /// The direction in which to allow collaborations.
    public let direction: CreateCollaborationWhitelistEntryRequestBodyDirectionField

    /// Initializer for a CreateCollaborationWhitelistEntryRequestBody.
    ///
    /// - Parameters:
    ///   - domain: The domain to add to the list of allowed domains.
    ///   - direction: The direction in which to allow collaborations.
    public init(domain: String, direction: CreateCollaborationWhitelistEntryRequestBodyDirectionField) {
        self.domain = domain
        self.direction = direction
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        domain = try container.decode(String.self, forKey: .domain)
        direction = try container.decode(CreateCollaborationWhitelistEntryRequestBodyDirectionField.self, forKey: .direction)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(domain, forKey: .domain)
        try container.encode(direction, forKey: .direction)
    }

}
