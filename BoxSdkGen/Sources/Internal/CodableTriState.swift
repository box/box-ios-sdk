import Foundation

/// A property wrapper that encodes and decodes a value with three distinct states:
/// - `.value(T)`: value is explicitly set
/// - `.null`: value is explicitly set to `nil`
/// - `.unset`: value is omitted during encoding
///
/// Used to differentiate between omitted and explicitly null fields in JSON APIs.
@propertyWrapper
public struct CodableTriState<T: Codable>: Codable {

    /// Internal state representing the wrapped value as a tri-state.
    var state: TriStateField<T> = .unset

    /// The unwrapped value exposed through the property wrapper.
    /// Returns `nil` if the value is `.null` or `.unset`.
    public var wrappedValue: T? {
        get { state.rawValue }
        set {
            if let newValue = newValue {
                state = .value(newValue)
            } else {
                state = .unset // Interpret direct nil assignment as "unset"
            }
        }
    }

    /// Default initializer. Initializes the state to `.unset`, meaning the value will be omitted when encoded.
    public init() {
        self.state = .unset
    }

    /// Initializes the wrapper with a wrapped value.
    /// - If the value is non-nil, state is `.value(value)`.
    /// - If the value is `nil`, state is `.unset`.
    public init(wrappedValue: T?) {
        self.state = TriStateField(wrappedValue: wrappedValue)
    }

    /// Initializes the wrapper with an explicit tri-state field.
    /// Allows you to set `.value`, `.null`, or `.unset` directly.
    public init(state: TriStateField<T>) {
        self.state = state
    }

    /// Decoding initializer. Delegates decoding to `TriStateField`.
    /// - Allows correct decoding of `.value`, `.null`, or omission.
    public init(from decoder: Decoder) throws {
        self.state = try TriStateField(from: decoder)
    }

    /// Encodes the wrapped value.
    /// - Encodes `.value(T)` normally.
    /// - Encodes `.null` as JSON null.
    /// - Omits field if `.unset`.
    public func encode(to encoder: Encoder) throws {
        try state.encode(to: encoder)
    }
}
