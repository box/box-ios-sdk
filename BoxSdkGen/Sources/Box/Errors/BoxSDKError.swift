import Foundation

/// Describes general errors
public class BoxSDKError: Error {
    /// The error message
    public let message: String
    /// The timestamp of the error
    public let timestamp: Date
    /// The underlying error which caused this error
    public let error: Error?
    /// The name of the error
    public let name: String

    public init(message: String, timestamp: Date? = nil, error: Error? = nil, name: String = "BoxSDKError") {
        self.message = message
        self.timestamp = timestamp ?? Date()
        self.error = error
        self.name = name
    }

    /// Gets a dictionary representing the BoxSDKError.
    ///
    /// - Returns: A dictionary representing the BoxSDKError.
    public func getDictionary() -> [String: Any] {
        var dict = [String: Any]()
        dict["name"] = name
        dict["timestamp"] = Utils.Dates.dateTimeToString(dateTime: timestamp)
        dict["message"] = message.description
        dict["error"] = error?.localizedDescription
        return dict
    }

}

/// Extension for `CustomStringConvertible` conformance
extension BoxSDKError: CustomStringConvertible {
    /// Provides error JSON string if found.
    public var description: String {
        guard
            let encodedData = try? JSONSerialization.data(withJSONObject: getDictionary(), options: [.prettyPrinted, .sortedKeys]),
            let JSONString = String(data: encodedData, encoding: .utf8)
        else {
            return "<Unparsed Error>"
        }
        return JSONString.replacingOccurrences(of: "\\", with: "")
    }
}
