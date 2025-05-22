import Foundation
import BoxSdkGen
import XCTest

class AppItemAssociationsManagerTests: XCTestCase {

    public func testListFileAppItemAssocations() async throws {
        let client: BoxClient = CommonsManager().getDefaultClientWithUserSubject(userId: Utils.getEnvironmentVariable(name: "USER_ID"))
        let fileId: String = Utils.getEnvironmentVariable(name: "APP_ITEM_ASSOCIATION_FILE_ID")
        let fileAppItemAssociations: AppItemAssociations = try await client.appItemAssociations.getFileAppItemAssociations(fileId: fileId)
        XCTAssertTrue(fileAppItemAssociations.entries!.count == 1)
        let association: AppItemAssociation = fileAppItemAssociations.entries![0]
        XCTAssertTrue(association.id != "")
        XCTAssertTrue(Utils.Strings.toString(value: association.appItem.applicationType) == "hubs")
        XCTAssertTrue(Utils.Strings.toString(value: association.appItem.type) == "app_item")
        let file: FileFull = try await client.files.getFileById(fileId: fileId, queryParams: GetFileByIdQueryParams(fields: ["is_associated_with_app_item"]))
        XCTAssertTrue(file.isAssociatedWithAppItem! == true)
    }

    public func testListFolderAppItemAssocations() async throws {
        let client: BoxClient = CommonsManager().getDefaultClientWithUserSubject(userId: Utils.getEnvironmentVariable(name: "USER_ID"))
        let folderId: String = Utils.getEnvironmentVariable(name: "APP_ITEM_ASSOCIATION_FOLDER_ID")
        let folderAppItemAssociations: AppItemAssociations = try await client.appItemAssociations.getFolderAppItemAssociations(folderId: folderId)
        XCTAssertTrue(folderAppItemAssociations.entries!.count == 1)
        let association: AppItemAssociation = folderAppItemAssociations.entries![0]
        XCTAssertTrue(association.id != "")
        XCTAssertTrue(Utils.Strings.toString(value: association.appItem.applicationType) == "hubs")
        XCTAssertTrue(Utils.Strings.toString(value: association.appItem.type) == "app_item")
        let folder: FolderFull = try await client.folders.getFolderById(folderId: folderId, queryParams: GetFolderByIdQueryParams(fields: ["is_associated_with_app_item"]))
        XCTAssertTrue(folder.isAssociatedWithAppItem! == true)
    }
}
