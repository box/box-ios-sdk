import Foundation

public enum FileOrFolderScopeScopeField: CodableStringEnum {
    case annotationEdit
    case annotationViewAll
    case annotationViewSelf
    case baseExplorer
    case basePicker
    case basePreview
    case baseUpload
    case itemDelete
    case itemDownload
    case itemPreview
    case itemRename
    case itemShare
    case itemUpload
    case itemRead
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "annotation_edit".lowercased():
            self = .annotationEdit
        case "annotation_view_all".lowercased():
            self = .annotationViewAll
        case "annotation_view_self".lowercased():
            self = .annotationViewSelf
        case "base_explorer".lowercased():
            self = .baseExplorer
        case "base_picker".lowercased():
            self = .basePicker
        case "base_preview".lowercased():
            self = .basePreview
        case "base_upload".lowercased():
            self = .baseUpload
        case "item_delete".lowercased():
            self = .itemDelete
        case "item_download".lowercased():
            self = .itemDownload
        case "item_preview".lowercased():
            self = .itemPreview
        case "item_rename".lowercased():
            self = .itemRename
        case "item_share".lowercased():
            self = .itemShare
        case "item_upload".lowercased():
            self = .itemUpload
        case "item_read".lowercased():
            self = .itemRead
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .annotationEdit:
            return "annotation_edit"
        case .annotationViewAll:
            return "annotation_view_all"
        case .annotationViewSelf:
            return "annotation_view_self"
        case .baseExplorer:
            return "base_explorer"
        case .basePicker:
            return "base_picker"
        case .basePreview:
            return "base_preview"
        case .baseUpload:
            return "base_upload"
        case .itemDelete:
            return "item_delete"
        case .itemDownload:
            return "item_download"
        case .itemPreview:
            return "item_preview"
        case .itemRename:
            return "item_rename"
        case .itemShare:
            return "item_share"
        case .itemUpload:
            return "item_upload"
        case .itemRead:
            return "item_read"
        case .customValue(let value):
            return value
        }
    }

}
