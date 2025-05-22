import Foundation

public class UpdateShieldInformationBarrierStatusRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case status
    }

    /// The ID of the shield information barrier.
    public let id: String

    /// The desired status for the shield information barrier.
    public let status: UpdateShieldInformationBarrierStatusRequestBodyStatusField

    /// Initializer for a UpdateShieldInformationBarrierStatusRequestBody.
    ///
    /// - Parameters:
    ///   - id: The ID of the shield information barrier.
    ///   - status: The desired status for the shield information barrier.
    public init(id: String, status: UpdateShieldInformationBarrierStatusRequestBodyStatusField) {
        self.id = id
        self.status = status
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        status = try container.decode(UpdateShieldInformationBarrierStatusRequestBodyStatusField.self, forKey: .status)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(status, forKey: .status)
    }

}
