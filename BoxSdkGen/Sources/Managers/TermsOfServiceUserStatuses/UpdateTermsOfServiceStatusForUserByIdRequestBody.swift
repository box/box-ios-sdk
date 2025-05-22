import Foundation

public class UpdateTermsOfServiceStatusForUserByIdRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case isAccepted = "is_accepted"
    }

    /// Whether the user has accepted the terms.
    public let isAccepted: Bool

    /// Initializer for a UpdateTermsOfServiceStatusForUserByIdRequestBody.
    ///
    /// - Parameters:
    ///   - isAccepted: Whether the user has accepted the terms.
    public init(isAccepted: Bool) {
        self.isAccepted = isAccepted
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isAccepted = try container.decode(Bool.self, forKey: .isAccepted)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isAccepted, forKey: .isAccepted)
    }

}
