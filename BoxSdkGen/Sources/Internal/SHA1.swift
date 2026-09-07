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

/// `SHA512` class provides an interface for calculating SHA-512 hash using different implementations based on platform availability.
internal class SHA512: SHA512Calculator {
    private let sha512Calculator: SHA512Calculator

    /// Initializes `SHA512` instance and selects appropriate SHA-512 calculator based on platform.
    init() {
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
        sha512Calculator = SHA512CommonCrypto()
#else
        sha512Calculator = SHA512Raw()
#endif
    }

    /// Updates the SHA-512 calculation with the given data chunk.
    ///
    /// - Parameter data: The data chunk to update the hash calculation.
    func update(data: Data) {
        sha512Calculator.update(data: data)
    }

    /// Finalizes the SHA-512 calculation and returns the computed hash.
    ///
    /// - Returns: The computed SHA-512 hash as `Data`.
    func finalize() -> Data {
        return sha512Calculator.finalize()
    }
}

/// Protocol defining methods required for SHA-512 calculation.
private protocol SHA512Calculator {
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
/// `SHA512CommonCrypto` class provides SHA-512 calculation using CommonCrypto library.
private class SHA512CommonCrypto: SHA512Calculator {
    private var context = CC_SHA512_CTX()

    init() {
        CC_SHA512_Init(&context)
    }

    /// Updates the SHA-512 calculation with the given data chunk using CommonCrypto.
    ///
    /// - Parameter data: The data chunk to update the hash calculation.
    func update(data: Data) {
        data.withUnsafeBytes { (bufferPointer: UnsafeRawBufferPointer) in
            guard let unsafeBufferPointerBaseAddress = bufferPointer.baseAddress else { return }
            let unsafePointer = unsafeBufferPointerBaseAddress.assumingMemoryBound(to: UInt8.self)
            CC_SHA512_Update(&context, unsafePointer, CC_LONG(data.count))
        }
    }

    /// Finalizes the SHA-512 calculation using CommonCrypto and returns the computed hash.
    ///
    /// - Returns: The computed SHA-512 hash as `Data`.
    func finalize() -> Data {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        CC_SHA512_Final(&digest, &context)
        return Data(digest)
    }
}
#endif

/// `SHA512Raw` class provides SHA-512 calculation using raw implementation.
private class SHA512Raw: SHA512Calculator {
    private static let initialHash: [UInt64] = [
        0x6a09e667f3bcc908,
        0xbb67ae8584caa73b,
        0x3c6ef372fe94f82b,
        0xa54ff53a5f1d36f1,
        0x510e527fade682d1,
        0x9b05688c2b3e6c1f,
        0x1f83d9abfb41bd6b,
        0x5be0cd19137e2179
    ]

    private static let k: [UInt64] = [
        0x428a2f98d728ae22, 0x7137449123ef65cd, 0xb5c0fbcfec4d3b2f, 0xe9b5dba58189dbbc,
        0x3956c25bf348b538, 0x59f111f1b605d019, 0x923f82a4af194f9b, 0xab1c5ed5da6d8118,
        0xd807aa98a3030242, 0x12835b0145706fbe, 0x243185be4ee4b28c, 0x550c7dc3d5ffb4e2,
        0x72be5d74f27b896f, 0x80deb1fe3b1696b1, 0x9bdc06a725c71235, 0xc19bf174cf692694,
        0xe49b69c19ef14ad2, 0xefbe4786384f25e3, 0x0fc19dc68b8cd5b5, 0x240ca1cc77ac9c65,
        0x2de92c6f592b0275, 0x4a7484aa6ea6e483, 0x5cb0a9dcbd41fbd4, 0x76f988da831153b5,
        0x983e5152ee66dfab, 0xa831c66d2db43210, 0xb00327c898fb213f, 0xbf597fc7beef0ee4,
        0xc6e00bf33da88fc2, 0xd5a79147930aa725, 0x06ca6351e003826f, 0x142929670a0e6e70,
        0x27b70a8546d22ffc, 0x2e1b21385c26c926, 0x4d2c6dfc5ac42aed, 0x53380d139d95b3df,
        0x650a73548baf63de, 0x766a0abb3c77b2a8, 0x81c2c92e47edaee6, 0x92722c851482353b,
        0xa2bfe8a14cf10364, 0xa81a664bbc423001, 0xc24b8b70d0f89791, 0xc76c51a30654be30,
        0xd192e819d6ef5218, 0xd69906245565a910, 0xf40e35855771202a, 0x106aa07032bbd1b8,
        0x19a4c116b8d2d0c8, 0x1e376c085141ab53, 0x2748774cdf8eeb99, 0x34b0bcb5e19b48a8,
        0x391c0cb3c5c95a63, 0x4ed8aa4ae3418acb, 0x5b9cca4f7763e373, 0x682e6ff3d6b2b8a3,
        0x748f82ee5defb2fc, 0x78a5636f43172f60, 0x84c87814a1f0ab72, 0x8cc702081a6439ec,
        0x90befffa23631e28, 0xa4506cebde82bde9, 0xbef9a3f7b2c67915, 0xc67178f2e372532b,
        0xca273eceea26619c, 0xd186b8c721c0c207, 0xeada7dd6cde0eb1e, 0xf57d4f7fee6ed178,
        0x06f067aa72176fba, 0x0a637dc5a2c898a6, 0x113f9804bef90dae, 0x1b710b35131c471b,
        0x28db77f523047d84, 0x32caab7b40c72493, 0x3c9ebe0a15c9bebc, 0x431d67c49c100d4c,
        0x4cc5d4becb3e42b6, 0x597f299cfc657e2a, 0x5fcb6fab3ad6faec, 0x6c44198c4a475817
    ]

    private var currentHash = SHA512Raw.initialHash
    private var messageLength: UInt64 = 0
    private var buffer: [UInt8] = []
    private var w = [UInt64](repeating: 0, count: 80)

    /// Updates the SHA-512 calculation with the given data chunk using raw implementation.
    ///
    /// - Parameter data: The data chunk to update the hash calculation.
    func update(data: Data) {
        data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            guard let baseAddress = bytes.baseAddress?.assumingMemoryBound(to: UInt8.self) else { return }
            let byteCount = bytes.count

            messageLength &+= UInt64(byteCount * 8)
            var dataPointer = baseAddress

            if !buffer.isEmpty {
                let remainingSpace = 128 - buffer.count
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

            while dataPointer.distance(to: baseAddress.advanced(by: byteCount)) >= 128 {
                processBlock(dataPointer)
                dataPointer = dataPointer.advanced(by: 128)
            }

            buffer.append(contentsOf: UnsafeBufferPointer(start: dataPointer, count: dataPointer.distance(to: baseAddress.advanced(by: byteCount))))
        }
    }

    /// Finalizes the SHA-512 calculation and returns the computed hash.
    ///
    /// - Returns: The computed SHA-512 hash as `Data`.
    func finalize() -> Data {
        var paddingLength = 128 - ((buffer.count + 16) % 128)
        if paddingLength == 0 { paddingLength = 128 }

        buffer.append(0x80)
        buffer.append(contentsOf: [UInt8](repeating: 0, count: paddingLength - 1))
        buffer.append(contentsOf: [UInt8](repeating: 0, count: 8))
        let lengthBytes = withUnsafeBytes(of: messageLength.bigEndian) { Array($0) }
        buffer.append(contentsOf: lengthBytes)

        var hashBuffer = [UInt8]()
        hashBuffer.reserveCapacity(64)

        buffer.withUnsafeBytes { bufferPointer in
            let bufferBaseAddress = bufferPointer.baseAddress!.assumingMemoryBound(to: UInt8.self)
            let bufferCount = buffer.count
            var dataPointer = bufferBaseAddress

            while dataPointer.distance(to: bufferBaseAddress.advanced(by: bufferCount)) >= 128 {
                processBlock(dataPointer)
                dataPointer = dataPointer.advanced(by: 128)
            }

            for value in currentHash {
                hashBuffer.append(contentsOf: withUnsafeBytes(of: value.bigEndian) { Array($0) })
            }
        }

        return Data(hashBuffer)
    }

    /// Processes a block of data during SHA-512 calculation.
    ///
    /// - Parameter chunk: The chunk of data to process.
    private func processBlock(_ chunk: UnsafePointer<UInt8>) {
        for i in 0..<16 {
            var word: UInt64 = 0
            for j in 0..<8 {
                word = (word << 8) | UInt64(chunk[(8 * i) + j])
            }
            w[i] = word
        }

        for i in 16..<80 {
            let s0 = SHA512Raw.rotateRight(w[i - 15], bits: 1) ^ SHA512Raw.rotateRight(w[i - 15], bits: 8) ^ (w[i - 15] >> 7)
            let s1 = SHA512Raw.rotateRight(w[i - 2], bits: 19) ^ SHA512Raw.rotateRight(w[i - 2], bits: 61) ^ (w[i - 2] >> 6)
            w[i] = w[i - 16] &+ s0 &+ w[i - 7] &+ s1
        }

        var a = currentHash[0]
        var b = currentHash[1]
        var c = currentHash[2]
        var d = currentHash[3]
        var e = currentHash[4]
        var f = currentHash[5]
        var g = currentHash[6]
        var h = currentHash[7]

        for i in 0..<80 {
            let s1 = SHA512Raw.rotateRight(e, bits: 14) ^ SHA512Raw.rotateRight(e, bits: 18) ^ SHA512Raw.rotateRight(e, bits: 41)
            let ch = (e & f) ^ (SHA512Raw.bitwiseNot(e) & g)
            let temp1 = h &+ s1 &+ ch &+ SHA512Raw.k[i] &+ w[i]
            let s0 = SHA512Raw.rotateRight(a, bits: 28) ^ SHA512Raw.rotateRight(a, bits: 34) ^ SHA512Raw.rotateRight(a, bits: 39)
            let maj = (a & b) ^ (a & c) ^ (b & c)
            let temp2 = s0 &+ maj

            h = g
            g = f
            f = e
            e = d &+ temp1
            d = c
            c = b
            b = a
            a = temp1 &+ temp2
        }

        currentHash[0] &+= a
        currentHash[1] &+= b
        currentHash[2] &+= c
        currentHash[3] &+= d
        currentHash[4] &+= e
        currentHash[5] &+= f
        currentHash[6] &+= g
        currentHash[7] &+= h
    }

    @inline(__always)
    private static func rotateRight(_ value: UInt64, bits: UInt64) -> UInt64 {
        return (value >> bits) | (value << (64 - bits))
    }

    @inline(__always)
    private static func bitwiseNot<T: FixedWidthInteger>(_ value: T) -> T {
        return value ^ T.max
    }
}
