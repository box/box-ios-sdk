import Foundation
import BoxSdkGen
import XCTest

class ClientManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testMakeRequestJsonCrud() async throws {
        let newFolderName: String = Utils.getUUID()
        let requestBodyPost: String = "\("{\"name\": \"")\(newFolderName)\("\", \"parent\": { \"id\": \"0\"}}")"
        let createFolderResponse: FetchResponse = try await client.makeRequest(fetchOptions: FetchOptions(url: "https://api.box.com/2.0/folders", method: "post", data: JsonUtils.jsonToSerializedData(text: requestBodyPost)))
        XCTAssertTrue(createFolderResponse.status == 201)
        let createdFolder: SerializedData = createFolderResponse.data!
        XCTAssertTrue(JsonUtils.getSdValueByKey(obj: createdFolder, key: "name") == newFolderName)
        let updatedName: String = Utils.getUUID()
        let requestBodyPut: String = "\("{\"name\": \"")\(updatedName)\("\"}")"
        let updateFolderResponse: FetchResponse = try await client.makeRequest(fetchOptions: FetchOptions(url: "\("https://api.box.com/2.0/folders/")\(JsonUtils.getSdValueByKey(obj: createdFolder, key: "id"))", method: "put", data: JsonUtils.jsonToSerializedData(text: requestBodyPut)))
        XCTAssertTrue(updateFolderResponse.status == 200)
        let updatedFolder: SerializedData = updateFolderResponse.data!
        XCTAssertTrue(JsonUtils.getSdValueByKey(obj: updatedFolder, key: "name") == updatedName)
        XCTAssertTrue(JsonUtils.getSdValueByKey(obj: updatedFolder, key: "id") == JsonUtils.getSdValueByKey(obj: createdFolder, key: "id"))
        let getFolderResponse: FetchResponse = try await client.makeRequest(fetchOptions: FetchOptions(url: "\("https://api.box.com/2.0/folders/")\(JsonUtils.getSdValueByKey(obj: createdFolder, key: "id"))", method: "GET"))
        XCTAssertTrue(getFolderResponse.status == 200)
        let receivedFolder: SerializedData = getFolderResponse.data!
        XCTAssertTrue(JsonUtils.getSdValueByKey(obj: receivedFolder, key: "name") == updatedName)
        XCTAssertTrue(JsonUtils.getSdValueByKey(obj: receivedFolder, key: "id") == JsonUtils.getSdValueByKey(obj: updatedFolder, key: "id"))
        let deleteFolderResponse: FetchResponse = try await client.makeRequest(fetchOptions: FetchOptions(url: "\("https://api.box.com/2.0/folders/")\(JsonUtils.getSdValueByKey(obj: receivedFolder, key: "id"))", method: "DELETE"))
        XCTAssertTrue(deleteFolderResponse.status == 204)
    }

    public func testMakeRequestMultipart() async throws {
        let newFolderName: String = Utils.getUUID()
        let newFolder: FolderFull = try await client.folders.createFolder(requestBody: CreateFolderRequestBody(name: newFolderName, parent: CreateFolderRequestBodyParentField(id: "0")))
        let newFolderId: String = newFolder.id
        let newFileName: String = "\(Utils.getUUID())\(".pdf")"
        let fileContentStream: InputStream = Utils.generateByteStream(size: 1024 * 1024)
        let multipartAttributes: String = "\("{\"name\": \"")\(newFileName)\("\", \"parent\": { \"id\":")\(newFolderId)\("}}")"
        let uploadFileResponse: FetchResponse = try await client.makeRequest(fetchOptions: FetchOptions(url: "https://upload.box.com/api/2.0/files/content", method: "POST", multipartData: [MultipartItem(partName: "attributes", data: JsonUtils.jsonToSerializedData(text: multipartAttributes)), MultipartItem(partName: "file", fileStream: fileContentStream)], contentType: "multipart/form-data"))
        XCTAssertTrue(uploadFileResponse.status == 201)
        try await client.folders.deleteFolderById(folderId: newFolderId, queryParams: DeleteFolderByIdQueryParams(recursive: true))
    }

    public func testMakeRequestBinaryFormat() async throws {
        let newFileName: String = Utils.getUUID()
        let fileBuffer: Data = Utils.generateByteBuffer(size: 1024 * 1024)
        let fileContentStream: InputStream = Utils.generateByteStreamFromBuffer(buffer: fileBuffer)
        let uploadedFiles: Files = try await client.uploads.uploadFile(requestBody: UploadFileRequestBody(attributes: UploadFileRequestBodyAttributesField(name: newFileName, parent: UploadFileRequestBodyAttributesParentField(id: "0")), file: fileContentStream))
        let uploadedFile: FileFull = uploadedFiles.entries![0]
        let destinationPathString: String = "\(Utils.temporaryDirectoryPath())\(Utils.getUUID())"
        let downloadFileResponse: FetchResponse = try await client.makeRequest(fetchOptions: FetchOptions(url: "\("https://api.box.com/2.0/files/")\(uploadedFile.id)\("/content")", method: "GET", responseFormat: ResponseFormat.binary, downloadDestinationUrl: URL(path: destinationPathString)))
        XCTAssertTrue(Utils.bufferEquals(buffer1: Utils.readBufferFromFile(filePath: destinationPathString), buffer2: fileBuffer))
        try await client.files.deleteFileById(fileId: uploadedFile.id)
    }

    public func testWithAsUserHeader() async throws {
        let userName: String = Utils.getUUID()
        let createdUser: UserFull = try await client.users.createUser(requestBody: CreateUserRequestBody(name: userName, isPlatformAccessOnly: true))
        let asUserClient: BoxClient = client.withAsUserHeader(userId: createdUser.id)
        let adminUser: UserFull = try await client.users.getUserMe()
        XCTAssertTrue(Utils.Strings.toString(value: adminUser.name) != userName)
        let appUser: UserFull = try await asUserClient.users.getUserMe()
        XCTAssertTrue(Utils.Strings.toString(value: appUser.name) == userName)
        try await client.users.deleteUserById(userId: createdUser.id)
    }

    public func testWithExtraHeaders() async throws {
        let userName: String = Utils.getUUID()
        let createdUser: UserFull = try await client.users.createUser(requestBody: CreateUserRequestBody(name: userName, isPlatformAccessOnly: true))
        let asUserClient: BoxClient = client.withExtraHeaders(extraHeaders: ["As-User": createdUser.id])
        let adminUser: UserFull = try await client.users.getUserMe()
        XCTAssertTrue(Utils.Strings.toString(value: adminUser.name) != userName)
        let appUser: UserFull = try await asUserClient.users.getUserMe()
        XCTAssertTrue(Utils.Strings.toString(value: appUser.name) == userName)
        try await client.users.deleteUserById(userId: createdUser.id)
    }

    public func testWithCustomBaseUrls() async throws {
        let newBaseUrls: BaseUrls = BaseUrls(baseUrl: "https://box.com/", uploadUrl: "https://box.com/", oauth2Url: "https://box.com/")
        let customBaseClient: BoxClient = client.withCustomBaseUrls(baseUrls: newBaseUrls)
        await XCTAssertThrowsErrorAsync(try await customBaseClient.users.getUserMe())
    }
}
