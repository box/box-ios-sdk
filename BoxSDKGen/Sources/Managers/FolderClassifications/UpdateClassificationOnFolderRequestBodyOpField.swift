import Foundation

public enum UpdateClassificationOnFolderRequestBodyOpField: CodableStringEnum {
    case replace
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "replace".lowercased():
            self = .replace
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .replace:
            return "replace"
        case .customValue(let value):
            return value
        }
    }

}
