import Foundation
import BoxSdkGen
import XCTest

class WebhooksManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testWebhooksCrud() async throws {
        let folder: FolderFull = try await client.folders.createFolder(requestBody: CreateFolderRequestBody(name: Utils.getUUID(), parent: CreateFolderRequestBodyParentField(id: "0")))
        let webhook: Webhook = try await client.webhooks.createWebhook(requestBody: CreateWebhookRequestBody(target: CreateWebhookRequestBodyTargetField(id: folder.id, type: CreateWebhookRequestBodyTargetTypeField.folder), address: "https://example.com/new-webhook", triggers: [CreateWebhookRequestBodyTriggersField.fileUploaded]))
        XCTAssertTrue(webhook.target!.id == folder.id)
        XCTAssertTrue(Utils.Strings.toString(value: webhook.target!.type) == "folder")
        XCTAssertTrue(webhook.triggers!.count == ["FILE.UPLOADED"].count)
        XCTAssertTrue(webhook.address == "https://example.com/new-webhook")
        let webhooks: Webhooks = try await client.webhooks.getWebhooks()
        XCTAssertTrue(webhooks.entries!.count > 0)
        let webhookFromApi: Webhook = try await client.webhooks.getWebhookById(webhookId: webhook.id!)
        XCTAssertTrue(webhook.id == webhookFromApi.id)
        XCTAssertTrue(webhook.target!.id == webhookFromApi.target!.id)
        XCTAssertTrue(webhook.address == webhookFromApi.address)
        let updatedWebhook: Webhook = try await client.webhooks.updateWebhookById(webhookId: webhook.id!, requestBody: UpdateWebhookByIdRequestBody(address: "https://example.com/updated-webhook"))
        XCTAssertTrue(updatedWebhook.id == webhook.id)
        XCTAssertTrue(updatedWebhook.address == "https://example.com/updated-webhook")
        try await client.webhooks.deleteWebhookById(webhookId: webhook.id!)
        await XCTAssertThrowsErrorAsync(try await client.webhooks.deleteWebhookById(webhookId: webhook.id!))
        try await client.folders.deleteFolderById(folderId: folder.id)
    }
}
