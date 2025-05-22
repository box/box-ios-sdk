import Foundation

public class CreateShieldInformationBarrierRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case enterprise
    }

    /// The `type` and `id` of enterprise this barrier is under.
    public let enterprise: EnterpriseBase

    /// Initializer for a CreateShieldInformationBarrierRequestBody.
    ///
    /// - Parameters:
    ///   - enterprise: The `type` and `id` of enterprise this barrier is under.
    public init(enterprise: EnterpriseBase) {
        self.enterprise = enterprise
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        enterprise = try container.decode(EnterpriseBase.self, forKey: .enterprise)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(enterprise, forKey: .enterprise)
    }

}
