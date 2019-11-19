import Foundation

/// Order direction.
public enum OrderDirection: BoxEnum {
    /// Items sorted in ascending order.
    case ascending
    /// Items sorted in descending order.
    case descending
    /// Custom
    case customValue(String)

    public init(_ value: String) {
        switch value.uppercased() {
        case "ASC":
            self = .ascending
        case "DESC":
            self = .descending
        default:
            self = .customValue(value)
        }
    }

    public var description: String {
        switch self {
        case .ascending:
            return "ASC"
        case .descending:
            return "DESC"
        case let .customValue(value):
            return value
        }
    }
}

/// Container for an entries (Box items)
public class EntryContainer<T: BoxModel>: BoxModel {
    // MARK: - BoxModel

    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Number of entries
    public let totalCount: Int?
    /// Entries in a container
    public let entries: [T]
    /// Paging offset
    public let offset: Int?
    /// Next paging marker value
    public let nextMarker: String?
    /// Next stream position
    public let nextStreamPosition: String?
    /// Maximum number of items per page
    public let limit: Int?
    /// Defines how entries are ordered
    public let order: [Order]?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json

        totalCount = try BoxJSONDecoder.optionalDecode(json: json, forKey: "total_count")
        offset = try BoxJSONDecoder.optionalDecode(json: json, forKey: "offset")
        nextMarker = try BoxJSONDecoder.optionalDecode(json: json, forKey: "next_marker")
        limit = try BoxJSONDecoder.optionalDecode(json: json, forKey: "limit")
        entries = try BoxJSONDecoder.decodeCollection(json: json, forKey: "entries")

        do {
            let intStreamPosition: Int = try BoxJSONDecoder.decode(json: json, forKey: "next_stream_position")
            nextStreamPosition = String(intStreamPosition)
        }
        catch {
            nextStreamPosition = nil
        }

        // Order is inconsistent in the API: sometimes it's an array and sometimes a single object value
        // Attempt to deserialize both ways, massaging it into an array for the model
        do {
            order = try BoxJSONDecoder.optionalDecodeCollection(json: json, forKey: "order")
        }
        catch {
            let singleOrder: Order = try BoxJSONDecoder.decode(json: json, forKey: "order")
            order = [singleOrder]
        }
    }
}

/// Defines the order of items
public class Order: BoxModel {
    // MARK: - BoxModel

    public private(set) var rawData: [String: Any]

    // MARK: - Properties

    /// Defines which parameters are items ordered by
    public let by: String?
    /// Defines direction of items order - ascending or descending
    public let direction: OrderDirection?

    /// Initializer.
    ///
    /// - Parameter json: JSON dictionary.
    /// - Throws: Decoding error.
    public required init(json: [String: Any]) throws {
        rawData = json
        by = try BoxJSONDecoder.optionalDecode(json: json, forKey: "by")
        direction = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "direction")
    }
}
