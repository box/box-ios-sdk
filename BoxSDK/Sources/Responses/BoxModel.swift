import Foundation

/// Defines Box SDK model behavior
public protocol BoxModel {

    /// Raw data from the API that populates the model
    var rawData: [String: Any] { get }

    /// Initializer.
    ///
    /// - Parameter json: JSON in a dictionary form
    /// - Throws: Decoding error
    init(json: [String: Any]) throws

    /// Initializer.
    ///
    /// - Parameter json: JSON data
    /// - Throws: Decoding error
    init(json: Data) throws

    /// Gets JSON string for a Box model object.
    ///
    /// - Returns: JSON string
    func json() -> String
}

/// Box inner model
public protocol BoxInnerModel: Codable {}

/// Extension for (de)serialization-related methods
public extension BoxModel {

    /// Gets JSON string for a Box model object.
    ///
    /// - Returns: JSON string
    func json() -> String {
        // swiftlint:disable:next force_try
        let data = try! JSONSerialization.data(withJSONObject: rawData, options: .prettyPrinted)
        // swiftlint:disable:next force_unwrapping
        return String(data: data, encoding: .utf8)!
    }

    /// Gets JSON string for a Box model object.
    ///
    /// - Returns: JSON string
    func toJSONString() -> String {
        return json()
    }

    /// "Deserialization" is just initialization the model with the original JSON.
    /// Initializer.
    ///
    /// - Parameter json: JSON data
    /// - Throws: Decoding error
    init(json: Data) throws {

        let jsonDict = try JSONSerialization.jsonObject(with: json, options: []) as? [String: Any]

        if let jsonDict = jsonDict {
            try self.init(json: jsonDict)
        }
        else {
            throw BoxAPIError(message: "Invalid response to initialize a BoxModel")
        }
    }
}
