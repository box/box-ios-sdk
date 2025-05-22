import Foundation
import BoxSdkGen
import XCTest

class SignTemplatesManagerTests: XCTestCase {

    public func testGetSignTemplates() async throws {
        let client: BoxClient = CommonsManager().getDefaultClientWithUserSubject(userId: Utils.getEnvironmentVariable(name: "USER_ID"))
        let signTemplates: SignTemplates = try await client.signTemplates.getSignTemplates(queryParams: GetSignTemplatesQueryParams(limit: Int64(2)))
        XCTAssertTrue(signTemplates.entries!.count >= 0)
    }

    public func testGetSignTemplate() async throws {
        let client: BoxClient = CommonsManager().getDefaultClientWithUserSubject(userId: Utils.getEnvironmentVariable(name: "USER_ID"))
        let signTemplates: SignTemplates = try await client.signTemplates.getSignTemplates(queryParams: GetSignTemplatesQueryParams(limit: Int64(2)))
        XCTAssertTrue(signTemplates.entries!.count >= 0)
        if signTemplates.entries!.count > 0 {
            let signTemplate: SignTemplate = try await client.signTemplates.getSignTemplateById(templateId: signTemplates.entries![0].id!)
            assert(signTemplate.id == signTemplates.entries![0].id)
            assert(signTemplate.sourceFiles!.count > 0)
            assert(signTemplate.name != "")
            assert(signTemplate.parentFolder!.id != "")
        }

    }
}
