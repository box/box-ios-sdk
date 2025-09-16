import Foundation

public enum GetFileThumbnailByIdExtension: CodableStringEnum {
    case png
    case jpg
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "png".lowercased():
            self = .png
        case "jpg".lowercased():
            self = .jpg
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .png:
            return "png"
        case .jpg:
            return "jpg"
        case .customValue(let value):
            return value
        }
    }

}
