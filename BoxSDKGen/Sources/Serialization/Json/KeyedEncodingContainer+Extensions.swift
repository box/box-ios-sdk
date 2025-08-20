import Foundation

extension KeyedEncodingContainer {

    /// Encodes a `TriStateField` value for a given key.
     ///
     /// - If the field is `.value`, the contained value is encoded.
     /// - If the field is `.null`, an explicit `null` is encoded.
     /// - If the field is `.unset`, the key is omitted from encoding.
     ///
     /// - Parameters:
     ///   - field: The `TriStateField` to encode.
     ///   - key: The key to associate with the encoded value.
     mutating func encode<T: Encodable>(field: TriStateField<T>, forKey key: KeyedEncodingContainer<K>.Key) throws {
         switch field {
         case .value(let v):
             try self.encode(v, forKey: key)
         case .null:
             try self.encodeNil(forKey: key)
         case .unset:
             break
         }
     }

     /// Encodes a `TriStateField<Date>` using a custom date format.
     ///
     /// Converts the `Date` to a formatted `String` before encoding.
     ///
     /// - Parameters:
     ///   - field: The `TriStateField<Date>` to encode.
     ///   - key: The key to associate with the encoded value.
     mutating func encodeDate<T: Encodable>(field: TriStateField<T>, forKey key: KeyedEncodingContainer<K>.Key) throws {
         switch field {
         case .value(let v):
             if let dateValue = v as? Date {
                 try self.encode(Utils.Dates.dateToString(date: dateValue), forKey: key)
             }
         case .null:
             try self.encodeNil(forKey: key)
         case .unset:
             break
         }
     }

     /// Encodes a `TriStateField<Date>` using a custom ISO date-time format.
     ///
     /// Converts the `Date` to a string like `"2024-01-01T12:00:00Z"` before encoding.
     ///
     /// - Parameters:
     ///   - field: The `TriStateField<Date>` to encode.
     ///   - key: The key to associate with the encoded value.
     mutating func encodeDateTime<T: Encodable>(field: TriStateField<T>, forKey key: KeyedEncodingContainer<K>.Key) throws {
         switch field {
         case .value(let v):
             if let dateTimeValue = v as? Date {
                 try self.encode(Utils.Dates.dateTimeToString(dateTime: dateTimeValue), forKey: key)
             }
         case .null:
             try self.encodeNil(forKey: key)
         case .unset:
             break
         }
     }

     /// Encodes a non-optional `Date` using a custom date format.
     ///
     /// Converts the `Date` to a formatted `String` before encoding.
     ///
     /// - Parameters:
     ///   - field: The `Date` to encode.
     ///   - key: The key to associate with the encoded value.
     mutating func encodeDate(field: Date, forKey key: KeyedEncodingContainer<K>.Key) throws {
         try self.encode(Utils.Dates.dateToString(date: field), forKey: key)
     }

     /// Encodes an optional `Date` using a custom date format if the value is present.
     ///
     /// Skips encoding if the date is `nil`.
     ///
     /// - Parameters:
     ///   - field: The optional `Date` to encode.
     ///   - key: The key to associate with the encoded value.
     mutating func encodeDateIfPresent(field: Date?, forKey key: KeyedEncodingContainer<K>.Key) throws {
         if let field {
             try encodeDate(field: field, forKey: key)
         }
     }

     /// Encodes a non-optional `Date` using ISO datetime format (`yyyy-MM-dd'T'HH:mm:ssZ`).
     ///
     /// - Parameters:
     ///   - field: The `Date` to encode.
     ///   - key: The key to associate with the encoded value.
     mutating func encodeDateTime(field: Date, forKey key: KeyedEncodingContainer<K>.Key) throws {
         try self.encode(Utils.Dates.dateTimeToString(dateTime: field), forKey: key)
     }

     /// Encodes an optional `Date` using ISO datetime format if the value is present.
     ///
     /// Skips encoding if the date is `nil`.
     ///
     /// - Parameters:
     ///   - field: The optional `Date` to encode.
     ///   - key: The key to associate with the encoded value.
     mutating func encodeDateTimeIfPresent(field: Date?, forKey key: KeyedEncodingContainer<K>.Key) throws {
         if let field {
             try encodeDateTime(field: field, forKey: key)
         }
     }
 }
