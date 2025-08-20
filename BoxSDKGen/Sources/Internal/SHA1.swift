import Foundation
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
import CommonCrypto
#endif

/// `SHA1` class provides an interface for calculating SHA-1 hash using different implementations based on platform availability.
internal class SHA1: SHA1Calculator {
    private let sha1Calculator: SHA1Calculator

    /// Initializes `SHA1` instance and selects appropriate SHA-1 calculator based on platform
    init() {
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
        sha1Calculator = SHA1CommonCrypto()
#else
        sha1Calculator = SHA1Raw()
#endif
    }

    /// Updates the SHA-1 calculation with the given data chunk.
    ///
    /// - Parameter data: The data chunk to update the hash calculation.
    func update(data: Data) {
        sha1Calculator.update(data: data)
    }

    /// Finalizes the SHA-1 calculation and returns the computed hash.
    ///
    /// - Returns: The computed SHA-1 hash as `Data`.
    func finalize() -> Data {
        return sha1Calculator.finalize()
    }
}

/// Protocol defining methods required for SHA-1 calculation.
private protocol SHA1Calculator {
    /// Updates the hash calculation with the given data.
    ///
    /// - Parameter data: The data to update the hash with.
    func update(data: Data)

    /// Finalizes the hash calculation and returns the computed hash.
    ///
    /// - Returns: The computed hash as `Data`.
    func finalize() -> Data
}

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
/// `SHA1CommonCrypto` class provides SHA-1 calculation using CommonCrypto library.
private class SHA1CommonCrypto: SHA1Calculator {
    private var context = CC_SHA1_CTX()

    init() {
        CC_SHA1_Init(&context)
    }

    /// Updates the SHA-1 calculation with the given data chunk using CommonCrypto.
    ///
    /// - Parameter data: The data chunk to update the hash calculation.
    func update(data: Data) {
        data.withUnsafeBytes { (bufferPointer: UnsafeRawBufferPointer) in
            guard let unsafeBufferPointerBaseAddress = bufferPointer.baseAddress else { return }
            let unsafePointer = unsafeBufferPointerBaseAddress.assumingMemoryBound(to: UInt8.self)
            CC_SHA1_Update(&context, unsafePointer, CC_LONG(data.count))
        }
    }

    /// Finalizes the SHA-1 calculation using CommonCrypto and returns the computed hash.
    ///
    /// - Returns: The computed SHA-1 hash as `Data`.
    func finalize() -> Data {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CC_SHA1_Final(&digest, &context)
        return Data(digest)
    }
}
#endif

/// `SHA1Raw` class provides SHA-1 calculation using raw implementation.
private class SHA1Raw: SHA1Calculator {
    private static let h0: UInt32 = 0x67452301
    private static let h1: UInt32 = 0xEFCDAB89
    private static let h2: UInt32 = 0x98BADCFE
    private static let h3: UInt32 = 0x10325476
    private static let h4: UInt32 = 0xC3D2E1F0

    private static let k1: UInt32 = 0x5A827999
    private static let k2: UInt32 = 0x6ED9EBA1
    private static let k3: UInt32 = 0x8F1BBCDC
    private static let k4: UInt32 = 0xCA62C1D6

    private var currentHash: [UInt32] = [SHA1Raw.h0, SHA1Raw.h1, SHA1Raw.h2, SHA1Raw.h3, SHA1Raw.h4]
    private var messageLength: UInt64 = 0
    private var buffer: [UInt8] = []

    private var w = [UInt32](repeating: 0, count: 80)

    /// Updates the SHA-1 calculation with the given data chunk using raw implementation.
    ///
    /// - Parameter data: The data chunk to update the hash calculation.
    func update(data: Data) {
        data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            guard let baseAddress = bytes.baseAddress?.assumingMemoryBound(to: UInt8.self) else { return }
            let byteCount = bytes.count

            messageLength &+= UInt64(byteCount * 8)
            var dataPointer = baseAddress

            if !buffer.isEmpty {
                let remainingSpace = 64 - buffer.count
                if byteCount >= remainingSpace {
                    buffer.append(contentsOf: UnsafeBufferPointer(start: dataPointer, count: remainingSpace))
                    buffer.withUnsafeBytes { bufferPointer in
                        processBlock(bufferPointer.baseAddress!.assumingMemoryBound(to: UInt8.self))
                    }
                    buffer.removeAll(keepingCapacity: true)
                    dataPointer = dataPointer.advanced(by: remainingSpace)
                } else {
                    buffer.append(contentsOf: UnsafeBufferPointer(start: dataPointer, count: byteCount))
                    return
                }
            }

            while dataPointer.distance(to: baseAddress.advanced(by: byteCount)) >= 64 {
                processBlock(dataPointer)
                dataPointer = dataPointer.advanced(by: 64)
            }

            buffer.append(contentsOf: UnsafeBufferPointer(start: dataPointer, count: dataPointer.distance(to: baseAddress.advanced(by: byteCount))))
        }
    }

    /// Finalizes the SHA-1 calculation and returns the computed hash.
    ///
    /// - Returns: The computed SHA-1 hash as `Data`.
    func finalize() -> Data {
        var paddingLength = 64 - ((buffer.count + 8) % 64)
        if paddingLength == 0 { paddingLength = 64 }

        buffer.append(0x80)
        buffer.append(contentsOf: [UInt8](repeating: 0, count: paddingLength - 1))

        let lengthBytes = withUnsafeBytes(of: messageLength.bigEndian) { Array($0) }
        buffer.append(contentsOf: lengthBytes)

        var hashBuffer = [UInt8]()
        hashBuffer.reserveCapacity(20)

        buffer.withUnsafeBytes { bufferPointer in
            let bufferBaseAddress = bufferPointer.baseAddress!.assumingMemoryBound(to: UInt8.self)
            let bufferCount = buffer.count
            var dataPointer = bufferBaseAddress

            while dataPointer.distance(to: bufferBaseAddress.advanced(by: bufferCount)) >= 64 {
                processBlock(dataPointer)
                dataPointer = dataPointer.advanced(by: 64)
            }

            // Convert UInt32 values in currentHash to big-endian bytes and append to hashBuffer
            for value in currentHash {
                let valueBytes = [
                    UInt8((value >> 24) & 0xFF),
                    UInt8((value >> 16) & 0xFF),
                    UInt8((value >> 8) & 0xFF),
                    UInt8(value & 0xFF)
                ]
                hashBuffer.append(contentsOf: valueBytes)
            }
        }

        return Data(hashBuffer)
    }

    /// Processes a block of data during SHA-1 calculation.
    ///
    /// - Parameter chunk: The chunk of data to process.
    private func processBlock(_ chunk: UnsafePointer<UInt8>) {
        for i in 0..<16 {
            w[i] = (UInt32(chunk[4 * i]) << 24) | (UInt32(chunk[4 * i + 1]) << 16) |
            (UInt32(chunk[4 * i + 2]) << 8) | (UInt32(chunk[4 * i + 3]))
        }

        for i in 16..<80 {
            w[i] = SHA1Raw.rotateLeft(w[i-3] ^ w[i-8] ^ w[i-14] ^ w[i-16], bits: 1)
        }

        var a = currentHash[0]
        var b = currentHash[1]
        var c = currentHash[2]
        var d = currentHash[3]
        var e = currentHash[4]

        for i in 0..<80 {
            let f: UInt32
            let k: UInt32

            switch i {
            case 0..<20:
                f = (b & c) | (SHA1Raw.bitwiseNot(b) & d)
                k = SHA1Raw.k1
            case 20..<40:
                f = b ^ c ^ d
                k = SHA1Raw.k2
            case 40..<60:
                f = (b & c) | (b & d) | (c & d)
                k = SHA1Raw.k3
            case 60..<80:
                f = b ^ c ^ d
                k = SHA1Raw.k4
            default:
                fatalError("Should not reach here")
            }

            let temp = SHA1Raw.rotateLeft(a, bits: 5) &+ f &+ e &+ k &+ w[i]
            e = d
            d = c
            c = SHA1Raw.rotateLeft(b, bits: 30)
            b = a
            a = temp
        }

        currentHash[0] &+= a
        currentHash[1] &+= b
        currentHash[2] &+= c
        currentHash[3] &+= d
        currentHash[4] &+= e
    }

    @inline(__always)
    private static func rotateLeft(_ value: UInt32, bits: UInt32) -> UInt32 {
        return (value << bits) | (value >> (32 - bits))
    }

    @inline(__always)
    private static func bitwiseNot<T: FixedWidthInteger>(_ value: T) -> T {
        return value ^ T.max
    }
}
