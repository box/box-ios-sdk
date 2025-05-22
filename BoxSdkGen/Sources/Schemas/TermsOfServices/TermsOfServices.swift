import Foundation

/// A list of terms of services
public class TermsOfServices: Codable {
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case entries
    }

    /// The total number of objects.
    public let totalCount: Int64?

    /// A list of terms of service objects
    public let entries: [TermsOfService]?

    /// Initializer for a TermsOfServices.
    ///
    /// - Parameters:
    ///   - totalCount: The total number of objects.
    ///   - entries: A list of terms of service objects
    public init(totalCount: Int64? = nil, entries: [TermsOfService]? = nil) {
        self.totalCount = totalCount
        self.entries = entries
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalCount = try container.decodeIfPresent(Int64.self, forKey: .totalCount)
        entries = try container.decodeIfPresent([TermsOfService].self, forKey: .entries)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(totalCount, forKey: .totalCount)
        try container.encodeIfPresent(entries, forKey: .entries)
    }

}
