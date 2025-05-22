import Foundation

/// Indicates which folder the report
/// file is located and any errors when generating the report.
public class ShieldInformationBarrierReportDetails: Codable {
    private enum CodingKeys: String, CodingKey {
        case details
    }

    public let details: ShieldInformationBarrierReportDetailsDetailsField?

    public init(details: ShieldInformationBarrierReportDetailsDetailsField? = nil) {
        self.details = details
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        details = try container.decodeIfPresent(ShieldInformationBarrierReportDetailsDetailsField.self, forKey: .details)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(details, forKey: .details)
    }

}
