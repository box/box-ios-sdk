import Foundation
import BoxSdkGen
import XCTest

class TermsOfServicesManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testGetTermsOfServices() async throws {
        let tos: TermsOfService = try await CommonsManager().getOrCreateTermsOfServices()
        let updatedTos1: TermsOfService = try await client.termsOfServices.updateTermsOfServiceById(termsOfServiceId: tos.id, requestBody: UpdateTermsOfServiceByIdRequestBody(status: UpdateTermsOfServiceByIdRequestBodyStatusField.disabled, text: "TOS"))
        XCTAssertTrue(Utils.Strings.toString(value: updatedTos1.status) == "disabled")
        XCTAssertTrue(updatedTos1.text == "TOS")
        let updatedTos2: TermsOfService = try await client.termsOfServices.updateTermsOfServiceById(termsOfServiceId: tos.id, requestBody: UpdateTermsOfServiceByIdRequestBody(status: UpdateTermsOfServiceByIdRequestBodyStatusField.disabled, text: "Updated TOS"))
        XCTAssertTrue(Utils.Strings.toString(value: updatedTos2.status) == "disabled")
        XCTAssertTrue(updatedTos2.text == "Updated TOS")
        let listTos: TermsOfServices = try await client.termsOfServices.getTermsOfService()
        XCTAssertTrue(listTos.totalCount! > 0)
    }
}
