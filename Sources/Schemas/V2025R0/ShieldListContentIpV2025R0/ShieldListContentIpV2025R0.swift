import Foundation

/// Representation of content of a Shield List that contains ip addresses data.
public class ShieldListContentIpV2025R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case ipAddresses = "ip_addresses"
        case type
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// List of ips and cidrs.
    public let ipAddresses: [String]

    /// The type of content in the shield list.
    public let type: ShieldListContentIpV2025R0TypeField

    /// Initializer for a ShieldListContentIpV2025R0.
    ///
    /// - Parameters:
    ///   - ipAddresses: List of ips and cidrs.
    ///   - type: The type of content in the shield list.
    public init(ipAddresses: [String], type: ShieldListContentIpV2025R0TypeField = ShieldListContentIpV2025R0TypeField.ip) {
        self.ipAddresses = ipAddresses
        self.type = type
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ipAddresses = try container.decode([String].self, forKey: .ipAddresses)
        type = try container.decode(ShieldListContentIpV2025R0TypeField.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ipAddresses, forKey: .ipAddresses)
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
