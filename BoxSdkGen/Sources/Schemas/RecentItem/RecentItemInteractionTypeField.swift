import Foundation

public enum RecentItemInteractionTypeField: CodableStringEnum {
    case itemPreview
    case itemUpload
    case itemComment
    case itemOpen
    case itemModify
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "item_preview".lowercased():
            self = .itemPreview
        case "item_upload".lowercased():
            self = .itemUpload
        case "item_comment".lowercased():
            self = .itemComment
        case "item_open".lowercased():
            self = .itemOpen
        case "item_modify".lowercased():
            self = .itemModify
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .itemPreview:
            return "item_preview"
        case .itemUpload:
            return "item_upload"
        case .itemComment:
            return "item_comment"
        case .itemOpen:
            return "item_open"
        case .itemModify:
            return "item_modify"
        case .customValue(let value):
            return value
        }
    }

}
