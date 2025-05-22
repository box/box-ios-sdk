import Foundation
import BoxSdkGen
import XCTest

class TermsOfServiceUserStatusesManagerTests: XCTestCase {

    public func testGetTermsOfServiceUserStatuses() async throws {
        let adminUserId: String = Utils.getEnvironmentVariable(name: "USER_ID")
        let client: BoxClient = CommonsManager().getDefaultClientWithUserSubject(userId: adminUserId)
        let tos: TermsOfService = try await CommonsManager().getOrCreateTermsOfServices()
        let user: UserFull = try await client.users.createUser(requestBody: CreateUserRequestBody(name: Utils.getUUID(), login: "\(Utils.getUUID())\("@boxdemo.com")", isPlatformAccessOnly: true))
        let createdTosUserStatus: TermsOfServiceUserStatus = try await client.termsOfServiceUserStatuses.createTermsOfServiceStatusForUser(requestBody: CreateTermsOfServiceStatusForUserRequestBody(tos: CreateTermsOfServiceStatusForUserRequestBodyTosField(id: tos.id), user: CreateTermsOfServiceStatusForUserRequestBodyUserField(id: user.id), isAccepted: false))
        XCTAssertTrue(createdTosUserStatus.isAccepted == false)
        XCTAssertTrue(Utils.Strings.toString(value: createdTosUserStatus.type) == "terms_of_service_user_status")
        XCTAssertTrue(Utils.Strings.toString(value: createdTosUserStatus.tos!.type) == "terms_of_service")
        XCTAssertTrue(Utils.Strings.toString(value: createdTosUserStatus.user!.type) == "user")
        XCTAssertTrue(createdTosUserStatus.tos!.id == tos.id)
        XCTAssertTrue(createdTosUserStatus.user!.id == user.id)
        let updatedTosUserStatus: TermsOfServiceUserStatus = try await client.termsOfServiceUserStatuses.updateTermsOfServiceStatusForUserById(termsOfServiceUserStatusId: createdTosUserStatus.id, requestBody: UpdateTermsOfServiceStatusForUserByIdRequestBody(isAccepted: true))
        XCTAssertTrue(updatedTosUserStatus.isAccepted == true)
        let listTosUserStatuses: TermsOfServiceUserStatuses = try await client.termsOfServiceUserStatuses.getTermsOfServiceUserStatuses(queryParams: GetTermsOfServiceUserStatusesQueryParams(tosId: tos.id, userId: user.id))
        XCTAssertTrue(listTosUserStatuses.totalCount! > 0)
        try await client.users.deleteUserById(userId: user.id)
    }
}
