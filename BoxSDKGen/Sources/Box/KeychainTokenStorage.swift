#if os(iOS) || os(tvOS) || os(watchOS) || os(OSX)
import Foundation

/// TokenStorage which keeps AccessToken directly in Keychain.
public class KeychainTokenStorage: TokenStorage {
    /// Default value for a keychain key.
    public static let defaultKeychainKey = "AccessToken"
    /// Default value for a service name.
    public static let defaultService = "swift-generated-sdk"

    /// The key under which the object is stored in the keychain, using the `kSecAttrAccount` attribute.
    private let keychainKey: String

    /// The service which provides a convenient access to keychain.
    private let keychainService: KeychainService

    /// Initializer
    ///
    /// - Parameters:
    ///   - keychainKey:The key under which the object is stored in the keychain, using the `kSecAttrAccount` attribute.
    ///   - service: Represents the service associated with stored item (`kSecAttrService`).
    public init(keychainKey: String = KeychainTokenStorage.defaultKeychainKey, service: String = KeychainTokenStorage.defaultService) {
        self.keychainService = KeychainService(secureStoreQueryable: GenericPasswordQueryable(service: service))
        self.keychainKey = keychainKey
    }

    /// Stores access token in keychain.
    ///
    /// - Parameters:
    ///   - token: The access token to store
    /// - Throws: The `GeneralError` if the operation fails for any reason.
    public func store(token: AccessToken) async throws {
        try keychainService.set(token, key: keychainKey)
    }

    /// Gets access token from keychain.
    ///
    /// - Returns: The stored access token.
    /// - Throws: The `GeneralError` if the operation fails for any reason.
    public func get() async throws -> AccessToken? {
        return try keychainService.getValue(keychainKey)
    }

    /// Clears access token in keychain
    /// - Throws: The `GeneralError` if the operation fails for any reason.
    public func clear() async throws {
        try keychainService.removeValue(for: self.keychainKey)
    }
}

/// Provides a convenient access to keychain.
struct KeychainService {
    let secureStoreQueryable: KeychainStoreQueryable

    /// Stores an encoded object in the keychain associated with the given key and with attributes in the `secureStoreQueryable` query.
    /// If there is already an entry in kechain with the given key, it will be overwritten.
    ///
    /// - Parameters:
    ///   - value: An object to store which should conforms to `Encodable`.
    ///   - key:The key under which the object will be stored.
    /// - Throws: The `GeneralError` if the operation fails for any reason.
    func set<T: Encodable>(_ value: T, key: String) throws {
        guard let data = try? value.encode() else {
            throw BoxSDKError(message: "Could not decode or encode data for or from keychain.")
        }

        var query = secureStoreQueryable.query
        query[String(kSecAttrAccount)] = key

        var status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            var attributesToUpdate: [String: Any] = [:]
            attributesToUpdate[String(kSecValueData)] = data
            status = SecItemUpdate(
                query as CFDictionary,
                attributesToUpdate as CFDictionary
            )
            if status != errSecSuccess {
                throw error(from: status)
            }
        case errSecItemNotFound:
            query[String(kSecValueData)] = data

            status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                throw error(from: status)
            }
        default:
            throw error(from: status)
        }
    }

    /// Gets a decoced object from the keychain matching the `secureStoreQueryable` query and the given key.
    ///
    /// - Parameters:
    ///   - key:The key under which the object is stored.
    /// - Returns: A decoced object from the keychain if present, otherwise nil.
    /// - Throws: The `GeneralError` if the operation fails for any reason.
    func getValue<T: Decodable>(_ key: String) throws -> T? {
        var query = secureStoreQueryable.query
        query[String(kSecMatchLimit)] = kSecMatchLimitOne
        query[String(kSecReturnAttributes)] = kCFBooleanTrue
        query[String(kSecReturnData)] = kCFBooleanTrue
        query[String(kSecAttrAccount)] = key

        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, $0)
        }

        switch status {
        case errSecSuccess:
            guard
                let queriedItem = queryResult as? [String: Any],
                let valueData = queriedItem[String(kSecValueData)] as? Data,
                let value = try? JSONDecoder().decode(T.self, from: valueData)
            else {
                throw BoxSDKError(message: "Could not decode or encode data for or from keychain.")
            }
            return value
        case errSecItemNotFound:
            return nil
        default:
            throw error(from: status)
        }
    }

    /// Removes the object with the given key from the keychain.
    ///
    /// - Parameters:
    ///   - key:The key under which the object is stored.
    /// - Throws: The `GeneralError` if the operation fails for any reason.
    func removeValue(for key: String) throws {
        var query = secureStoreQueryable.query
        query[String(kSecAttrAccount)] = key

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw error(from: status)
        }
    }

    /// Removes objects from the keychain that mach the `secureStoreQueryable` query.
    ///
    /// - Throws: The `GeneralError` if the operation fails for any reason.
    func removeAllValues() throws {
        let query = secureStoreQueryable.query

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw error(from: status)
        }
    }

    /// Creates an error based on the `OSStatus`
    /// - Returns: The `GeneralError` with the message based on `OSStatus`
    func error(from status: OSStatus) -> BoxSDKError {
        let message = SecCopyErrorMessageString(status, nil) as String? ?? NSLocalizedString("Unhandled Error", comment: "")
        return BoxSDKError(message: "Unhandled keychain error: \(message)")
    }
}

/// A protocol representing the query attributes.
protocol KeychainStoreQueryable {
    var query: [String: Any] { get }
}

/// A type representing a general keychain password query.
struct GenericPasswordQueryable: KeychainStoreQueryable {
    let service: String
    let accessGroup: String?

    init(service: String, accessGroup: String? = nil) {
        self.service = service
        self.accessGroup = accessGroup
    }

    var query: [String: Any] {
        var query: [String: Any] = [:]
        query[String(kSecClass)] = kSecClassGenericPassword
        query[String(kSecAttrService)] = service

        // Access group if target environment is not simulator
#if !targetEnvironment(simulator)
        if let accessGroup = accessGroup {
            query[String(kSecAttrAccessGroup)] = accessGroup
        }
#endif
        return query
    }
}
#endif
