import Foundation

public class CreateInviteRequestBody: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case enterprise
        case actionableBy = "actionable_by"
        case isAutoRollInEnabled = "is_auto_roll_in_enabled"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The enterprise to invite the user to.
    public let enterprise: CreateInviteRequestBodyEnterpriseField

    /// The user to invite.
    public let actionableBy: CreateInviteRequestBodyActionableByField

    /// If set to `true`, the user is added to the enterprise
    /// automatically after 14 days instead of having to accept the
    /// invite. Only unmanaged users can be invited this way.
    /// Availability depends on the enterprise's plan.
    public let isAutoRollInEnabled: Bool?

    /// Initializer for a CreateInviteRequestBody.
    ///
    /// - Parameters:
    ///   - enterprise: The enterprise to invite the user to.
    ///   - actionableBy: The user to invite.
    ///   - isAutoRollInEnabled: If set to `true`, the user is added to the enterprise
    ///     automatically after 14 days instead of having to accept the
    ///     invite. Only unmanaged users can be invited this way.
    ///     Availability depends on the enterprise's plan.
    public init(enterprise: CreateInviteRequestBodyEnterpriseField, actionableBy: CreateInviteRequestBodyActionableByField, isAutoRollInEnabled: Bool? = nil) {
        self.enterprise = enterprise
        self.actionableBy = actionableBy
        self.isAutoRollInEnabled = isAutoRollInEnabled
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        enterprise = try container.decode(CreateInviteRequestBodyEnterpriseField.self, forKey: .enterprise)
        actionableBy = try container.decode(CreateInviteRequestBodyActionableByField.self, forKey: .actionableBy)
        isAutoRollInEnabled = try container.decodeIfPresent(Bool.self, forKey: .isAutoRollInEnabled)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(enterprise, forKey: .enterprise)
        try container.encode(actionableBy, forKey: .actionableBy)
        try container.encodeIfPresent(isAutoRollInEnabled, forKey: .isAutoRollInEnabled)
    }

    /// Sets the raw JSON data.
    ///
    /// - Parameters:
    ///   - rawData: A dictionary containing the raw JSON data
    func setRawData(rawData: [String: Any]?) {
        self._rawData = rawData
    }

    /// Gets the raw JSON data
    /// - Returns: The `[String: Any]?`.
    func getRawData() -> [String: Any]? {
        return self._rawData
    }

}
