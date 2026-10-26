import Foundation

public class ShuttleJobCreateRequestV2026R0AccountMappingField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case isEnabled = "is_enabled"
        case permissionConflictStrategy = "permission_conflict_strategy"
        case areExternalSharesMapped = "are_external_shares_mapped"
        case arePermissionsMapped = "are_permissions_mapped"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Whether account mapping is enabled for the shuttle job. Defaults to
    /// `false` when `account_mapping` is omitted on create.
    public let isEnabled: Bool?

    /// The strategy used to resolve permission conflicts. `null` when
    /// unset.
    public let permissionConflictStrategy: ShuttleJobPermissionConflictStrategyV2026R0?

    /// Whether external shares are mapped during the migration.
    public let areExternalSharesMapped: Bool?

    /// Whether permissions are mapped during the migration.
    public let arePermissionsMapped: Bool?

    /// Initializer for a ShuttleJobCreateRequestV2026R0AccountMappingField.
    ///
    /// - Parameters:
    ///   - isEnabled: Whether account mapping is enabled for the shuttle job. Defaults to
    ///     `false` when `account_mapping` is omitted on create.
    ///   - permissionConflictStrategy: The strategy used to resolve permission conflicts. `null` when
    ///     unset.
    ///   - areExternalSharesMapped: Whether external shares are mapped during the migration.
    ///   - arePermissionsMapped: Whether permissions are mapped during the migration.
    public init(isEnabled: Bool? = nil, permissionConflictStrategy: ShuttleJobPermissionConflictStrategyV2026R0? = nil, areExternalSharesMapped: Bool? = nil, arePermissionsMapped: Bool? = nil) {
        self.isEnabled = isEnabled
        self.permissionConflictStrategy = permissionConflictStrategy
        self.areExternalSharesMapped = areExternalSharesMapped
        self.arePermissionsMapped = arePermissionsMapped
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isEnabled = try container.decodeIfPresent(Bool.self, forKey: .isEnabled)
        permissionConflictStrategy = try container.decodeIfPresent(ShuttleJobPermissionConflictStrategyV2026R0.self, forKey: .permissionConflictStrategy)
        areExternalSharesMapped = try container.decodeIfPresent(Bool.self, forKey: .areExternalSharesMapped)
        arePermissionsMapped = try container.decodeIfPresent(Bool.self, forKey: .arePermissionsMapped)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(isEnabled, forKey: .isEnabled)
        try container.encodeIfPresent(permissionConflictStrategy, forKey: .permissionConflictStrategy)
        try container.encodeIfPresent(areExternalSharesMapped, forKey: .areExternalSharesMapped)
        try container.encodeIfPresent(arePermissionsMapped, forKey: .arePermissionsMapped)
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
