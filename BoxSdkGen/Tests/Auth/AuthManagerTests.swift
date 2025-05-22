import Foundation
import BoxSdkGen
import XCTest

class AuthManagerTests: XCTestCase {

    public func testOauthAuthAuthorizeUrl() async throws {
        let config: OAuthConfig = OAuthConfig(clientId: "OAUTH_CLIENT_ID", clientSecret: "OAUTH_CLIENT_SECRET")
        let auth: BoxOAuth = BoxOAuth(config: config)
        let authUrl: String = try auth.getAuthorizeUrl()
        XCTAssertTrue(authUrl == "https://account.box.com/api/oauth2/authorize?client_id=OAUTH_CLIENT_ID&response_type=code" || authUrl == "https://account.box.com/api/oauth2/authorize?response_type=code&client_id=OAUTH_CLIENT_ID")
    }

    public func testCcgAuth() async throws {
        let userId: String = Utils.getEnvironmentVariable(name: "USER_ID")
        let enterpriseId: String = Utils.getEnvironmentVariable(name: "ENTERPRISE_ID")
        let ccgConfig: CCGConfig = CCGConfig(clientId: Utils.getEnvironmentVariable(name: "CLIENT_ID"), clientSecret: Utils.getEnvironmentVariable(name: "CLIENT_SECRET"), enterpriseId: enterpriseId, userId: userId)
        let auth: BoxCCGAuth = BoxCCGAuth(config: ccgConfig)
        let userAuth: BoxCCGAuth = auth.withUserSubject(userId: userId)
        let userClient: BoxClient = BoxClient(auth: userAuth)
        let currentUser: UserFull = try await userClient.users.getUserMe()
        XCTAssertTrue(currentUser.id == userId)
        let enterpriseAuth: BoxCCGAuth = auth.withEnterpriseSubject(enterpriseId: enterpriseId)
        let enterpriseClient: BoxClient = BoxClient(auth: enterpriseAuth)
        let newUser: UserFull = try await enterpriseClient.users.getUserMe(queryParams: GetUserMeQueryParams(fields: ["enterprise"]))
        XCTAssertTrue(newUser.enterprise != nil)
        XCTAssertTrue(newUser.enterprise!.id == enterpriseId)
        XCTAssertTrue(newUser.id != userId)
    }

    public func testCcgAuthDownscope() async throws {
        let ccgConfig: CCGConfig = CCGConfig(clientId: Utils.getEnvironmentVariable(name: "CLIENT_ID"), clientSecret: Utils.getEnvironmentVariable(name: "CLIENT_SECRET"), userId: Utils.getEnvironmentVariable(name: "USER_ID"))
        let auth: BoxCCGAuth = BoxCCGAuth(config: ccgConfig)
        let parentClient: BoxClient = BoxClient(auth: auth)
        let folder: FolderFull = try await parentClient.folders.createFolder(requestBody: CreateFolderRequestBody(name: Utils.getUUID(), parent: CreateFolderRequestBodyParentField(id: "0")))
        let resourcePath: String = "\("https://api.box.com/2.0/folders/")\(folder.id)"
        let downscopedToken: AccessToken = try await auth.downscopeToken(scopes: ["item_rename", "item_preview"], resource: resourcePath)
        XCTAssertTrue(downscopedToken.accessToken != nil)
        let downscopedClient: BoxClient = BoxClient(auth: BoxDeveloperTokenAuth(token: downscopedToken.accessToken!))
        try await downscopedClient.folders.updateFolderById(folderId: folder.id, requestBody: UpdateFolderByIdRequestBody(name: Utils.getUUID()))
        await XCTAssertThrowsErrorAsync(try await downscopedClient.folders.deleteFolderById(folderId: folder.id))
        try await parentClient.folders.deleteFolderById(folderId: folder.id)
    }

    public func testCcgAuthRevoke() async throws {
        let ccgConfig: CCGConfig = CCGConfig(clientId: Utils.getEnvironmentVariable(name: "CLIENT_ID"), clientSecret: Utils.getEnvironmentVariable(name: "CLIENT_SECRET"), userId: Utils.getEnvironmentVariable(name: "USER_ID"))
        let auth: BoxCCGAuth = BoxCCGAuth(config: ccgConfig)
        let tokenFromStorageBeforeRevoke: AccessToken = try await auth.retrieveToken()
        XCTAssertTrue(tokenFromStorageBeforeRevoke != nil)
        try await auth.revokeToken()
        let tokenFromStorageAfterRevoke: AccessToken = try await auth.retrieveToken()
        XCTAssertTrue(tokenFromStorageBeforeRevoke.accessToken != tokenFromStorageAfterRevoke.accessToken)
    }

    public func getAccessToken() async throws -> AccessToken {
        let userId: String = Utils.getEnvironmentVariable(name: "USER_ID")
        let enterpriseId: String = Utils.getEnvironmentVariable(name: "ENTERPRISE_ID")
        let ccgConfig: CCGConfig = CCGConfig(clientId: Utils.getEnvironmentVariable(name: "CLIENT_ID"), clientSecret: Utils.getEnvironmentVariable(name: "CLIENT_SECRET"), enterpriseId: enterpriseId, userId: userId)
        let auth: BoxCCGAuth = BoxCCGAuth(config: ccgConfig)
        let authUser: BoxCCGAuth = auth.withUserSubject(userId: userId)
        return try await authUser.retrieveToken()
    }

    public func testDeveloperTokenAuthRevoke() async throws {
        let developerTokenConfig: DeveloperTokenConfig = DeveloperTokenConfig(clientId: Utils.getEnvironmentVariable(name: "CLIENT_ID"), clientSecret: Utils.getEnvironmentVariable(name: "CLIENT_SECRET"))
        let token: AccessToken = try await getAccessToken()
        let auth: BoxDeveloperTokenAuth = BoxDeveloperTokenAuth(token: token.accessToken!, config: developerTokenConfig)
        let tokenFromStorageBeforeRevoke: AccessToken = try await auth.retrieveToken()
        XCTAssertTrue(tokenFromStorageBeforeRevoke != nil)
        try await auth.revokeToken()
        await XCTAssertThrowsErrorAsync(try await auth.retrieveToken())
    }

    public func testDeveloperTokenAuthDownscope() async throws {
        let developerTokenConfig: DeveloperTokenConfig = DeveloperTokenConfig(clientId: Utils.getEnvironmentVariable(name: "CLIENT_ID"), clientSecret: Utils.getEnvironmentVariable(name: "CLIENT_SECRET"))
        let token: AccessToken = try await getAccessToken()
        let auth: BoxDeveloperTokenAuth = BoxDeveloperTokenAuth(token: token.accessToken!, config: developerTokenConfig)
        let parentClient: BoxClient = BoxClient(auth: auth)
        let folder: FolderFull = try await parentClient.folders.createFolder(requestBody: CreateFolderRequestBody(name: Utils.getUUID(), parent: CreateFolderRequestBodyParentField(id: "0")))
        let resourcePath: String = "\("https://api.box.com/2.0/folders/")\(folder.id)"
        let downscopedToken: AccessToken = try await auth.downscopeToken(scopes: ["item_rename", "item_preview"], resource: resourcePath)
        XCTAssertTrue(downscopedToken.accessToken != nil)
        let downscopedClient: BoxClient = BoxClient(auth: BoxDeveloperTokenAuth(token: downscopedToken.accessToken!))
        try await downscopedClient.folders.updateFolderById(folderId: folder.id, requestBody: UpdateFolderByIdRequestBody(name: Utils.getUUID()))
        await XCTAssertThrowsErrorAsync(try await downscopedClient.folders.deleteFolderById(folderId: folder.id))
        try await parentClient.folders.deleteFolderById(folderId: folder.id)
    }

    public func testDeveloperTokenAuth() async throws {
        let userId: String = Utils.getEnvironmentVariable(name: "USER_ID")
        let token: AccessToken = try await getAccessToken()
        let devAuth: BoxDeveloperTokenAuth = BoxDeveloperTokenAuth(token: token.accessToken!)
        let client: BoxClient = BoxClient(auth: devAuth)
        let currentUser: UserFull = try await client.users.getUserMe()
        XCTAssertTrue(currentUser.id == userId)
    }

    public func testOauthAuthRevoke() async throws {
        let token: AccessToken = try await getAccessToken()
        let tokenStorage: InMemoryTokenStorage = InMemoryTokenStorage(token: token)
        let config: OAuthConfig = OAuthConfig(clientId: Utils.getEnvironmentVariable(name: "CLIENT_ID"), clientSecret: Utils.getEnvironmentVariable(name: "CLIENT_SECRET"), tokenStorage: tokenStorage)
        let auth: BoxOAuth = BoxOAuth(config: config)
        let client: BoxClient = BoxClient(auth: auth)
        try await client.users.getUserMe()
        try await auth.revokeToken()
        await XCTAssertThrowsErrorAsync(try await client.users.getUserMe())
    }

    public func testOauthAuthDownscope() async throws {
        let token: AccessToken = try await getAccessToken()
        let tokenStorage: InMemoryTokenStorage = InMemoryTokenStorage(token: token)
        let config: OAuthConfig = OAuthConfig(clientId: Utils.getEnvironmentVariable(name: "CLIENT_ID"), clientSecret: Utils.getEnvironmentVariable(name: "CLIENT_SECRET"), tokenStorage: tokenStorage)
        let auth: BoxOAuth = BoxOAuth(config: config)
        let parentClient: BoxClient = BoxClient(auth: auth)
        let uploadedFiles: Files = try await parentClient.uploads.uploadFile(requestBody: UploadFileRequestBody(attributes: UploadFileRequestBodyAttributesField(name: Utils.getUUID(), parent: UploadFileRequestBodyAttributesParentField(id: "0")), file: Utils.generateByteStream(size: 1024 * 1024)))
        let file: FileFull = uploadedFiles.entries![0]
        let resourcePath: String = "\("https://api.box.com/2.0/files/")\(file.id)"
        let downscopedToken: AccessToken = try await auth.downscopeToken(scopes: ["item_rename", "item_preview"], resource: resourcePath)
        XCTAssertTrue(downscopedToken.accessToken != nil)
        let downscopedClient: BoxClient = BoxClient(auth: BoxDeveloperTokenAuth(token: downscopedToken.accessToken!))
        try await downscopedClient.files.updateFileById(fileId: file.id, requestBody: UpdateFileByIdRequestBody(name: Utils.getUUID()))
        await XCTAssertThrowsErrorAsync(try await downscopedClient.files.deleteFileById(fileId: file.id))
        try await parentClient.files.deleteFileById(fileId: file.id)
    }
}
