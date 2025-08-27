import Foundation

/// Representation of content of a Shield List that contains domains data.
public class ShieldListContentDomainV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case domains
        case type
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// List of domain.
    public let domains: [String]

    /// The type of content in the shield list.
    public let type: ShieldListContentDomainV2025R0TypeField

    /// Initializer for a ShieldListContentDomainV2025R0.
    ///
    /// - Parameters:
    ///   - domains: List of domain.
    ///   - type: The type of content in the shield list.
    public init(domains: [String], type: ShieldListContentDomainV2025R0TypeField = ShieldListContentDomainV2025R0TypeField.domain) {
        self.domains = domains
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        domains = try container.decode([String].self, forKey: .domains)
        type = try container.decode(ShieldListContentDomainV2025R0TypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(domains, forKey: .domains)
        try container.encode(type, forKey: .type)
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
