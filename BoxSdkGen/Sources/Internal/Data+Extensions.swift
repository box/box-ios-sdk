import Foundation

/// Extension providing convenience methods for handling data.
public extension Data {

    /// Initializes `Data` from a value of generic type `T`.
    ///
    /// - Parameter value: The value to convert into `Data`.
    internal init<T>(value: T) {
        self = withUnsafePointer(to: value) { (ptr: UnsafePointer<T>) -> Data in
            return Data(buffer: UnsafeBufferPointer(start: ptr, count: 1))
        }
    }

    /// Appends a value of generic type `T` to the end of `Data`.
    ///
    /// - Parameter value: The value to append to `Data`.
    internal mutating func append<T>(value: T) {
        withUnsafePointer(to: value) { (ptr: UnsafePointer<T>) in
            append(UnsafeBufferPointer(start: ptr, count: 1))
        }
    }

    /// Initializes `Data` from a hexadecimal string.
    ///
    /// - Parameter hex: The hexadecimal string representation of the data.
    /// - Returns: An optional `Data` object initialized from the hexadecimal string, or `nil` if the string is invalid.
    init?(fromHexString hex: String) {
        guard hex.count % 2 == 0 else {
            return nil
        }

        var data = Data()
        var index = hex.startIndex
        while index < hex.endIndex {
            let nextIndex = hex.index(index, offsetBy: 2)
            let byteString = hex[index..<nextIndex]
            guard let byte = UInt8(byteString, radix: 16) else {
                return nil
            }
            data.append(byte)
            index = nextIndex
        }

        self = data
    }

    /// Returns the `Data` object as a base64-encoded string.
    ///
    /// - Returns: A base64-encoded string representation of the `Data`.
    func base64EncodedString() -> String {
        return self.base64EncodedString(options: [])
    }

    /// Returns the `Data` object as a hexadecimal string.
    ///
    /// - Returns: A hexadecimal string representation of the `Data`.
    func hexString() -> String {
        let hexBytes = self.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}
