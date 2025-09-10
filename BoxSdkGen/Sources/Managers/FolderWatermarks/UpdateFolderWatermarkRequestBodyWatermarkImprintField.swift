import Foundation

public enum UpdateFolderWatermarkRequestBodyWatermarkImprintField: CodableStringEnum {
    case default_
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "default".lowercased():
            self = .default_
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .default_:
            return "default"
        case .customValue(let value):
            return value
        }
    }

}
