import Foundation

/// A list of integration mapping
/// objects.
public class IntegrationMappingsTeams: Codable {
    private enum CodingKeys: String, CodingKey {
        case entries
    }

    /// A list of integration mappings
    public let entries: [IntegrationMappingTeams]?

    /// Initializer for a IntegrationMappingsTeams.
    ///
    /// - Parameters:
    ///   - entries: A list of integration mappings
    public init(entries: [IntegrationMappingTeams]? = nil) {
        self.entries = entries
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        entries = try container.decodeIfPresent([IntegrationMappingTeams].self, forKey: .entries)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(entries, forKey: .entries)
    }

}
