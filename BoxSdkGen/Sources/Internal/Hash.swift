import Foundation

/// Enum defining available hashing algorithms.
public enum HashName {
    /// SHA-1 hashing algorithm.
    case sha1
    /// SHA-512 hashing algorithm.
    case sha512
}

/// Class for hashing data using a specified algorithm.
public class Hash {
    private static let Base64Encoding = "base64"

    private let algorithm: HashName
    private let sha1: SHA1?
    private let sha512: SHA512?
    private var digest: Data?

    /// Initializes a `Hash` instance with the specified algorithm.
    ///
    /// - Parameter algorithm: The hashing algorithm to use.
    public init(algorithm: HashName) {
        self.algorithm = algorithm
        switch algorithm {
        case .sha1:
            self.sha1 = SHA1()
            self.sha512 = nil
        case .sha512:
            self.sha1 = nil
            self.sha512 = SHA512()
        }
        self.digest = nil
    }

    /// Updates the hash with additional data.
    ///
    /// - Parameter data: The data to append to the hash.
    public func updateHash(data: Data) {
        switch algorithm {
        case .sha1:
            self.sha1?.update(data: data)
        case .sha512:
            self.sha512?.update(data: data)
        }
    }

    /// Calculates the digest of the accumulated data using the specified encoding.
    ///
    /// - Parameter encoding: The string encoding to use for the digest result.
    /// - Returns: The base64-encoded or hexadecimal string representation of the hash digest.
    public func digestHash(encoding: String) async -> String {
        if digest == nil {
            switch algorithm {
            case .sha1:
                digest = sha1?.finalize()
            case .sha512:
                digest = sha512?.finalize()
            }
        }

        guard let digest = digest else {
            return ""
        }

        if encoding == Self.Base64Encoding {
            return digest.base64EncodedString()
        } else {
            return digest.hexString()
        }
    }
}
