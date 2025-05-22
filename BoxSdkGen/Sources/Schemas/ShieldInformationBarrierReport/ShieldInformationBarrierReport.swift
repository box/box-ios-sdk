import Foundation

/// A standard representation
/// of a shield information barrier report object
public class ShieldInformationBarrierReport: ShieldInformationBarrierReportBase {
    private enum CodingKeys: String, CodingKey {
        case shieldInformationBarrier = "shield_information_barrier"
        case status
        case details
        case createdAt = "created_at"
        case createdBy = "created_by"
        case updatedAt = "updated_at"
    }

    public let shieldInformationBarrier: ShieldInformationBarrierReference?

    /// Status of the shield information report
    public let status: ShieldInformationBarrierReportStatusField?

    public let details: ShieldInformationBarrierReportDetails?

    /// ISO date time string when this
    /// shield information barrier report object was created.
    public let createdAt: Date?

    public let createdBy: UserBase?

    /// ISO date time string when this
    /// shield information barrier report was updated.
    public let updatedAt: Date?

    /// Initializer for a ShieldInformationBarrierReport.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the shield information barrier report
    ///   - type: The type of the shield information barrier report
    ///   - shieldInformationBarrier: 
    ///   - status: Status of the shield information report
    ///   - details: 
    ///   - createdAt: ISO date time string when this
    ///     shield information barrier report object was created.
    ///   - createdBy: 
    ///   - updatedAt: ISO date time string when this
    ///     shield information barrier report was updated.
    public init(id: String? = nil, type: ShieldInformationBarrierReportBaseTypeField? = nil, shieldInformationBarrier: ShieldInformationBarrierReference? = nil, status: ShieldInformationBarrierReportStatusField? = nil, details: ShieldInformationBarrierReportDetails? = nil, createdAt: Date? = nil, createdBy: UserBase? = nil, updatedAt: Date? = nil) {
        self.shieldInformationBarrier = shieldInformationBarrier
        self.status = status
        self.details = details
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.updatedAt = updatedAt

        super.init(id: id, type: type)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        shieldInformationBarrier = try container.decodeIfPresent(ShieldInformationBarrierReference.self, forKey: .shieldInformationBarrier)
        status = try container.decodeIfPresent(ShieldInformationBarrierReportStatusField.self, forKey: .status)
        details = try container.decodeIfPresent(ShieldInformationBarrierReportDetails.self, forKey: .details)
        createdAt = try container.decodeDateTimeIfPresent(forKey: .createdAt)
        createdBy = try container.decodeIfPresent(UserBase.self, forKey: .createdBy)
        updatedAt = try container.decodeDateTimeIfPresent(forKey: .updatedAt)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(shieldInformationBarrier, forKey: .shieldInformationBarrier)
        try container.encodeIfPresent(status, forKey: .status)
        try container.encodeIfPresent(details, forKey: .details)
        try container.encodeDateTimeIfPresent(field: createdAt, forKey: .createdAt)
        try container.encodeIfPresent(createdBy, forKey: .createdBy)
        try container.encodeDateTimeIfPresent(field: updatedAt, forKey: .updatedAt)
        try super.encode(to: encoder)
    }

}
