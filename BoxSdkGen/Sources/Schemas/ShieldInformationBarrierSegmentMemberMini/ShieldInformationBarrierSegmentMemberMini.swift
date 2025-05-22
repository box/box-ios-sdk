import Foundation

/// A mini representation of a
/// shield information barrier segment member object
public class ShieldInformationBarrierSegmentMemberMini: ShieldInformationBarrierSegmentMemberBase {
    private enum CodingKeys: String, CodingKey {
        case user
    }

    public let user: UserBase?

    /// Initializer for a ShieldInformationBarrierSegmentMemberMini.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the
    ///     shield information barrier segment member
    ///   - type: The type of the shield information barrier segment member
    ///   - user: 
    public init(id: String? = nil, type: ShieldInformationBarrierSegmentMemberBaseTypeField? = nil, user: UserBase? = nil) {
        self.user = user

        super.init(id: id, type: type)
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        user = try container.decodeIfPresent(UserBase.self, forKey: .user)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(user, forKey: .user)
        try super.encode(to: encoder)
    }

}
