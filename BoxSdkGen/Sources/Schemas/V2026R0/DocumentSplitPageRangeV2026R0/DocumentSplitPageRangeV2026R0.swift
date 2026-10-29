import Foundation

/// An inclusive page range used to define one slice of a manual Document Split job.
public class DocumentSplitPageRangeV2026R0: Codable, RawJSONReadable {
    private enum CodingKeys: String, CodingKey {
        case start
        case end
    }

    /// Internal backing store for rawData. Used to store raw dictionary data associated with the instance.
    private var _rawData: [String: Any]?

    /// Returns the raw dictionary data associated with the instance. This is a read-only property.
    public var rawData: [String: Any]? {
        return _rawData
    }


    /// The first page (inclusive) included in this slice.
    public let start: Int

    /// The last page (inclusive) included in this slice.
    public let end: Int

    /// Initializer for a DocumentSplitPageRangeV2026R0.
    ///
    /// - Parameters:
    ///   - start: The first page (inclusive) included in this slice.
    ///   - end: The last page (inclusive) included in this slice.
    public init(start: Int, end: Int) {
        self.start = start
        self.end = end
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        start = try container.decode(Int.self, forKey: .start)
        end = try container.decode(Int.self, forKey: .end)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(start, forKey: .start)
        try container.encode(end, forKey: .end)
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
