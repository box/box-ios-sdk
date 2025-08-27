import Foundation

/// Indicates which folder the report
/// file is located and any errors when generating the report.
public class ShieldInformationBarrierReportDetails: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case details
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    public let details: ShieldInformationBarrierReportDetailsDetailsField?

    public init(details: ShieldInformationBarrierReportDetailsDetailsField? = nil) {
        self.details = details
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        details = try container.decodeIfPresent(ShieldInformationBarrierReportDetailsDetailsField.self, forKey: .details)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(details, forKey: .details)
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
