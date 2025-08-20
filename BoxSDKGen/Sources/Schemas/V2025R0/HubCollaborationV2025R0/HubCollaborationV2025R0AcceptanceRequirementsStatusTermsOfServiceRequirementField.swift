import Foundation

public class HubCollaborationV2025R0AcceptanceRequirementsStatusTermsOfServiceRequirementField: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case isAccepted = "is_accepted"
        case termsOfService = "terms_of_service"
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// Whether or not the terms of service have been accepted.  The
    /// field is `null` when there is no terms of service required.
    @CodableTriState public private(set) var isAccepted: Bool?

    public let termsOfService: TermsOfServiceBaseV2025R0?

    /// Initializer for a HubCollaborationV2025R0AcceptanceRequirementsStatusTermsOfServiceRequirementField.
    ///
    /// - Parameters:
    ///   - isAccepted: Whether or not the terms of service have been accepted.  The
    ///     field is `null` when there is no terms of service required.
    ///   - termsOfService: 
    public init(isAccepted: TriStateField<Bool> = nil, termsOfService: TermsOfServiceBaseV2025R0? = nil) {
        self._isAccepted = CodableTriState(state: isAccepted)
        self.termsOfService = termsOfService
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isAccepted = try container.decodeIfPresent(Bool.self, forKey: .isAccepted)
        termsOfService = try container.decodeIfPresent(TermsOfServiceBaseV2025R0.self, forKey: .termsOfService)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(field: _isAccepted.state, forKey: .isAccepted)
        try container.encodeIfPresent(termsOfService, forKey: .termsOfService)
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
