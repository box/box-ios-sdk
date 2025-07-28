import Foundation

extension KeyedDecodingContainer {

    /// Decodes a `TriStateField` for a given key.
    ///
    /// - If the key is present and the value is non-nil, returns `.value(T)`.
    /// - If the key is present and the value is `null`, returns `.null`.
    /// - If the key is not present at all, returns `.unset`.
    ///
    /// - Parameter key: The key to decode.
    /// - Returns: A `TriStateField<T>` representing the decoded state.
    func decodeTriState<T: Decodable>(forKey key: KeyedDecodingContainer<K>.Key) throws -> TriStateField<T> {
        if contains(key) {
            if try decodeNil(forKey: key) {
                return .null
            } else {
                let value = try decode(T.self, forKey: key)
                return .value(value)
            }
        } else {
            return .unset
        }
    }

    /// Decodes an optional `Date` from a string value if present, using a custom date format.
    ///
    /// - Parameter key: The key to decode.
    /// - Returns: A `Date` if decoding succeeds, otherwise `nil`.
    func decodeDateIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Date? {
        if let valueString = try self.decodeIfPresent(String.self, forKey: key) {
            return try Utils.Dates.dateFromString(date: valueString)
        } else {
            return nil
        }
    }

    /// Decodes a required `Date` from a string using a custom date format.
    ///
    /// - Parameter key: The key to decode.
    /// - Returns: A `Date` if decoding succeeds.
    /// - Throws: An error if the decoding or parsing fails.
    func decodeDate(forKey key: KeyedDecodingContainer<K>.Key) throws -> Date {
        return try Utils.Dates.dateFromString(date: try self.decode(String.self, forKey: key))
    }

    /// Decodes an optional `Date` in full ISO datetime format if present.
    ///
    /// Expected format: `"yyyy-MM-dd'T'HH:mm:ssZ"` (e.g., `"2024-01-01T12:00:00Z"`)
    ///
    /// - Parameter key: The key to decode.
    /// - Returns: A `Date` if decoding succeeds, otherwise `nil`.
    func decodeDateTimeIfPresent(forKey key: KeyedDecodingContainer<K>.Key) throws -> Date? {
        if let valueString = try self.decodeIfPresent(String.self, forKey: key) {
            return try Utils.Dates.dateTimeFromString(dateTime: valueString)
        } else {
            return nil
        }
    }

    /// Decodes a required `Date` from a string in ISO datetime format.
    ///
    /// Expected format: `"yyyy-MM-dd'T'HH:mm:ssZ"`
    ///
    /// - Parameter key: The key to decode.
    /// - Returns: A `Date` if decoding succeeds.
    /// - Throws: An error if decoding or date parsing fails.
    func decodeDateTime(forKey key: KeyedDecodingContainer<K>.Key) throws -> Date {
        return try Utils.Dates.dateTimeFromString(dateTime: try self.decode(String.self, forKey: key))
    }
}
