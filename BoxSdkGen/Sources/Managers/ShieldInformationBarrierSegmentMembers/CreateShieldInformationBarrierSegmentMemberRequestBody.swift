import Foundation

public class CreateShieldInformationBarrierSegmentMemberRequestBody: Codable {
    private enum CodingKeys: String, CodingKey {
        case shieldInformationBarrierSegment = "shield_information_barrier_segment"
        case user
        case type
        case shieldInformationBarrier = "shield_information_barrier"
    }

    /// The `type` and `id` of the
    /// requested shield information barrier segment.
    public let shieldInformationBarrierSegment: CreateShieldInformationBarrierSegmentMemberRequestBodyShieldInformationBarrierSegmentField

    /// User to which restriction will be applied.
    public let user: UserBase

    /// -| A type of the shield barrier segment member.
    public let type: CreateShieldInformationBarrierSegmentMemberRequestBodyTypeField?

    public let shieldInformationBarrier: ShieldInformationBarrierBase?

    /// Initializer for a CreateShieldInformationBarrierSegmentMemberRequestBody.
    ///
    /// - Parameters:
    ///   - shieldInformationBarrierSegment: The `type` and `id` of the
    ///     requested shield information barrier segment.
    ///   - user: User to which restriction will be applied.
    ///   - type: -| A type of the shield barrier segment member.
    ///   - shieldInformationBarrier: 
    public init(shieldInformationBarrierSegment: CreateShieldInformationBarrierSegmentMemberRequestBodyShieldInformationBarrierSegmentField, user: UserBase, type: CreateShieldInformationBarrierSegmentMemberRequestBodyTypeField? = nil, shieldInformationBarrier: ShieldInformationBarrierBase? = nil) {
        self.shieldInformationBarrierSegment = shieldInformationBarrierSegment
        self.user = user
        self.type = type
        self.shieldInformationBarrier = shieldInformationBarrier
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        shieldInformationBarrierSegment = try container.decode(CreateShieldInformationBarrierSegmentMemberRequestBodyShieldInformationBarrierSegmentField.self, forKey: .shieldInformationBarrierSegment)
        user = try container.decode(UserBase.self, forKey: .user)
        type = try container.decodeIfPresent(CreateShieldInformationBarrierSegmentMemberRequestBodyTypeField.self, forKey: .type)
        shieldInformationBarrier = try container.decodeIfPresent(ShieldInformationBarrierBase.self, forKey: .shieldInformationBarrier)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(shieldInformationBarrierSegment, forKey: .shieldInformationBarrierSegment)
        try container.encode(user, forKey: .user)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(shieldInformationBarrier, forKey: .shieldInformationBarrier)
    }

}
