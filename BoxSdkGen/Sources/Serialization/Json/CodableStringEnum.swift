/// Defines protocol convertible to query parameter
public protocol CodableStringEnum: RawRepresentable, Codable, ParameterConvertible { }

extension CodableStringEnum  where RawValue == String {
    public var paramValue: String? {
        return self.rawValue
    }
}
