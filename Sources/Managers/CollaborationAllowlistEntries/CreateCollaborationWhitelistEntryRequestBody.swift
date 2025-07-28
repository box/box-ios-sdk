import Foundation

public class CreateCollaborationWhitelistEntryRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case domain
        case direction
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
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
