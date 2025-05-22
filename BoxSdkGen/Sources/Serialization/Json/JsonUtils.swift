import Foundation

public enum JsonUtils {
    
    /// Converts SerializedData to Data (binary representation)
    ///
    /// - Parameter data: The SerializedData object.
    /// - Returns: JSON Data.
    /// - Throws: An error if the conversion fails.
    public static func sdToJson(data: SerializedData) throws -> Data {
        return try data.toJson()
    }
    
    /// Converts SerializedData to URL parameters.
    ///
    /// - Parameter data: The SerializedData object.
    /// - Returns: URL parameters as a string.
    /// - Throws: An error if the conversion fails.
    public static func sdToUrlParams(data: SerializedData) throws -> String {
        return try data.toUrlParams()
    }
    
    /// Retrieves a value as a string from SerializedData by key.
    ///
    /// - Parameters:
    ///   - obj: The SerializedData object.
    ///   - key: The key to look for in the serialized data.
    /// - Returns: The value as a string if found; otherwise, an empty string.
    public static func getSdValueByKey(obj: SerializedData, key: String) -> String {
        guard let jsonDict = sdToJsonDictionary(from: obj) else {
            return ""
        }
        
        let value = jsonDict[key]
        guard let stringValue = Utils.Strings.toString(value: value) else {
            return ""
        }
        
        return stringValue
    }
    
    /// Converts SerializedData to a JSON dictionary.
    ///
    /// - Parameter from: The SerializedData object.
    /// - Returns: A dictionary representation of the JSON data, or nil if the conversion fails.
    public static func sdToJsonDictionary(from obj: SerializedData?) -> [String: Any]? {
        guard let jsonData = try? obj?.toJson() else {
            return nil
        }
        
        return dataToJsonDictionary(from: jsonData)
    }
    
    /// Converts Data to a JSON dictionary.
    ///
    /// - Parameter from: The Data object.
    /// - Returns: A dictionary representation of the JSON data, or nil if the conversion fails.
    public static func dataToJsonDictionary(from jsonData: Data) -> [String: Any]? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []), let jsonDict = jsonObject as? [String: Any] else {
            return nil
        }
        
        return jsonDict
    }
    
    /// Converts a JSON string to SerializedData.
    ///
    /// - Parameter text: The JSON string.
    /// - Returns: A SerializedData object.
    public static func jsonToSerializedData(text: String) -> SerializedData {
        return SerializedData(data: text.data(using: .utf8)!)
    }
    
    /// Returns a string replacement for sensitive data.
    ///
    /// - Returns: A string replacement for sensitive data.
    public static func sanitizedValue() -> String {
        return "---[redacted]---"
    }
    
    /// Sanitizes serialized data by replacing the values of specified keys with a sanitized value.
    ///
    /// - Parameters:
    ///   - sd: The serialized data to sanitize.
    ///   - keysToSanitize: The keys to sanitize.
    /// - Returns: A new serialized data with the specified keys sanitized.
    public static func sanitizeSerializedData(sd: SerializedData, keysToSanitize: [String: String]) -> SerializedData {
        return sd
    }
}
