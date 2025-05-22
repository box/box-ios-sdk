import Foundation

/// Specifies which `date` field on the template to filter the search
/// results by, specifying a range of dates that can match.
public class MetadataFieldFilterDateRange: Codable {
    private enum CodingKeys: String, CodingKey {
        case lt
        case gt
    }

    /// Specifies the (inclusive) upper bound for the metadata field
    /// value. The value of a field must be lower than (`lt`) or
    /// equal to this value for the search query to match this
    /// template.
    public let lt: Date?

    /// Specifies the (inclusive) lower bound for the metadata field
    /// value. The value of a field must be greater than (`gt`) or
    /// equal to this value for the search query to match this
    /// template.
    public let gt: Date?

    /// Initializer for a MetadataFieldFilterDateRange.
    ///
    /// - Parameters:
    ///   - lt: Specifies the (inclusive) upper bound for the metadata field
    ///     value. The value of a field must be lower than (`lt`) or
    ///     equal to this value for the search query to match this
    ///     template.
    ///   - gt: Specifies the (inclusive) lower bound for the metadata field
    ///     value. The value of a field must be greater than (`gt`) or
    ///     equal to this value for the search query to match this
    ///     template.
    public init(lt: Date? = nil, gt: Date? = nil) {
        self.lt = lt
        self.gt = gt
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lt = try container.decodeDateTimeIfPresent(forKey: .lt)
        gt = try container.decodeDateTimeIfPresent(forKey: .gt)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeDateTimeIfPresent(field: lt, forKey: .lt)
        try container.encodeDateTimeIfPresent(field: gt, forKey: .gt)
    }

}
