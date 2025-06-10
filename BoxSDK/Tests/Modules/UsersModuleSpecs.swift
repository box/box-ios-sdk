//
//  UsersModuleSpecs.swift
//  BoxSDK
//
//  Created by Abel Osorio on 3/29/19.
//  Copyright © 2019 Box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class UsersModuleSpecs: QuickSpec {

    override class func spec() {
        var sut: BoxClient!

        beforeEach {
            sut = BoxSDK.getClient(token: "dasda")
        }

        afterEach {
            HTTPStubs.removeAllStubs()
        }

        describe("Users Module") {
            describe("get()") {
                it("should make API call to retrieve user and produce user model when API call succeeds") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/users/10543463") && isMethodGET()) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetUserInfo.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.users.get(userId: "10543463") { result in
                            switch result {
                            case let .success(user):
                                expect(user).toNot(beNil())
                                expect(user).to(beAKindOf(User.self))
                                expect(user.id).to(equal("11111"))
                                expect(user.name).to(equal("Test User"))
                                expect(user.login).to(equal("testuser@example.com"))
                                expect(user.language).to(equal("en"))
                                expect(user.timezone).to(equal("America/Los_Angeles"))
                                expect(user.spaceAmount).to(equal(10_737_418_240))
                                expect(user.spaceUsed).to(equal(558_732))
                                expect(user.maxUploadSize).to(equal(5_368_709_120))
                                expect(user.status).to(equal(.active))
                                expect(user.avatarUrl).to(equal(URL(string: "https://app.box.com/api/avatar/deprecated")!))
                                expect(user.jobTitle).to(equal(""))
                                expect(user.phone).to(equal(""))
                                expect(user.address).to(equal(""))
                                expect(user.type).to(equal("user"))
                            case let .failure(error):
                                fail("Expected call to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should send fields as comma-separated values when field parameter is passed") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/users/10543463") && isMethodGET() && containsQueryParams(["fields": "type,id,name"])) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetUserInfo.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.users.get(userId: "10543463", fields: ["type", "id", "name"]) { result in
                            switch result {
                            case let .success(user):
                                expect(user).toNot(beNil())
                                expect(user).to(beAKindOf(User.self))
                                expect(user.id).to(equal("11111"))
                                expect(user.name).to(equal("Test User"))
                                expect(user.type).to(equal("user"))
                            case let .failure(error):
                                fail("Expected call to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("uploadAvatar()") {
                it("should upload an image and return valid response") {
                    let image = TestAssets.image(named: "image")!
                    let data = image.pngData()!

                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/users/10543463/avatar")

                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "UploadUserAvatar.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(100)) { done in
                        sut.users.uploadAvatar(
                            userId: "10543463",
                            data: data,
                            name: "avatar.png"
                        ) { result in
                            switch result {
                            case let .success(userAvatarUpload):
                                expect(userAvatarUpload).toNot(beNil())
                                expect(userAvatarUpload).to(beAKindOf(UserAvatarUpload.self))
                                expect(userAvatarUpload.picUrls.preview).toNot(beNil() && beEmpty())
                                expect(userAvatarUpload.picUrls.small).toNot(beNil() && beEmpty())
                                expect(userAvatarUpload.picUrls.large).toNot(beNil() && beEmpty())
                            case let .failure(error):
                                fail("Expected call to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("streamUploadAvatar()") {
                it("should upload an image and return valid response") {
                    let image = TestAssets.image(named: "image")!
                    let stream = InputStream(data: image.pngData()!)

                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/users/10543463/avatar")

                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "UploadUserAvatar.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(100)) { done in
                        sut.users.streamUploadAvatar(
                            userId: "10543463",
                            stream: stream,
                            name: "avatar.png"
                        ) { result in
                            switch result {
                            case let .success(userAvatarUpload):
                                expect(userAvatarUpload).toNot(beNil())
                                expect(userAvatarUpload).to(beAKindOf(UserAvatarUpload.self))
                                expect(userAvatarUpload.picUrls.preview).toNot(beNil() && beEmpty())
                                expect(userAvatarUpload.picUrls.small).toNot(beNil() && beEmpty())
                                expect(userAvatarUpload.picUrls.large).toNot(beNil() && beEmpty())
                            case let .failure(error):
                                fail("Expected call to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("getAvatar()") {
                it("download user's avatar") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/users/10543463/avatar") &&
                            isMethodGET()
                    ) { _ in
                        let image = TestAssets.image(named: "image")!
                        let data = image.jpegData(compressionQuality: 1.0)!
                        return HTTPStubsResponse(data: data, statusCode: 200, headers: [:])
                    }

                    waitUntil(timeout: .seconds(100)) { done in
                        sut.users.getAvatar(userId: "10543463") { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("deleteAvatar()") {
                it("should delete a user avatar") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/users/10543463/avatar") &&
                            isMethodDELETE()
                    ) { _ in
                        HTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.users.deleteAvatar(userId: "10543463") { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected deleteAvatar call to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("create()") {
                it("should create new user") {
                    stub(
                        condition: isHost("api.box.com") &&
                            isPath("/2.0/users") &&
                            isMethodPOST() &&
                            hasJsonBody(["login": "testuser@example.com",
                                         "name": "Test User",
                                         "role": UserRole.user.description,
                                         "language": "en",
                                         "phone": "555-555-5555",
                                         "address": "555 Box Lane",
                                         "timezone": "America/Los_Angeles",
                                         "status": UserStatus.active.description])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "CreateUser.json")!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(100)) { done in
                        sut.users.create(
                            login: "testuser@example.com",
                            name: "Test User",
                            role: .user,
                            language: "en",
                            phone: "555-555-5555",
                            address: "555 Box Lane",
                            timezone: "America/Los_Angeles",
                            status: .active,
                            completion: { result in
                                switch result {
                                case let .success(newUser):
                                    expect(newUser).toNot(beNil())
                                    expect(newUser.name).to(equal("Test User"))
                                    expect(newUser.login).to(equal("testuser@example.com"))
                                    expect(newUser.role).to(equal(UserRole.user.description))
                                    expect(newUser.status).to(equal(UserStatus.active))
                                    expect(newUser.language).to(equal("en"))
                                    expect(newUser.timezone).to(equal("America/Los_Angeles"))
                                    expect(newUser.phone).to(equal("555-555-5555"))
                                    expect(newUser.address).to(equal("555 Box Lane"))
                                case let .failure(error):
                                    fail("Expected call to succeed, but it got \(error)")
                                }
                                done()
                            }
                        )
                    }
                }
            }

            describe("getCurrent()") {
                it("should retreive current user information") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/users/me") && isMethodGET()) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetCurrentUserInfo.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.users.getCurrent { result in
                            switch result {
                            case let .success(user):
                                expect(user).toNot(beNil())
                                expect(user).to(beAKindOf(User.self))
                                expect(user.id).to(equal("17738362"))
                                expect(user.name).to(equal("Test User"))
                                expect(user.login).to(equal("testuser@example.com"))
                                expect(user.language).to(equal("en"))
                                expect(user.timezone).to(beNil())
                                expect(user.spaceAmount).to(equal(5_368_709_120))
                                expect(user.spaceUsed).to(equal(2_377_016))
                                expect(user.maxUploadSize).to(equal(262_144_000))
                                expect(user.status).to(equal(.active))
                                expect(user.avatarUrl).to(equal(URL(string: "https://app.box.com/api/avatar/deprecated")!))
                                expect(user.jobTitle).to(equal("Employee"))
                                expect(user.phone).to(equal("5555555555"))
                                expect(user.address).to(equal("555 Office Drive"))
                            case let .failure(error):
                                fail("Expected call to getCurrentUser to succeed, but it failed: \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("createAppUser()") {
                it("should create a new app user") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/users") && isMethodPOST() && hasJsonBody(["name": "Test User", "is_platform_access_only": true])) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "CreateAppUser.json")!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.users.createAppUser(name: "Test User") { result in
                            switch result {
                            case let .success(newAppUser):
                                expect(newAppUser).toNot(beNil())
                                expect(newAppUser.name).to(equal("Test User"))
                                expect(newAppUser.login).to(equal("testuser@example.com"))
                            case let .failure(error):
                                fail("Expected call to succeed, but it got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("update()") {
                it("should send correct JSON to update tracking codes when parameter is passed") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/users/123456")
                            && isMethodPUT()
                            && self.compareJSONBody([
                                "tracking_codes": [
                                    [
                                        "name": "foo",
                                        "value": "bar"
                                    ]
                                ]
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "UpdateUser.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    let trackingCode = User.TrackingCode(name: "foo", value: "bar")

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.users.update(userId: "123456", trackingCodes: [trackingCode]) { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to succeed, but it got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("delete()") {
                it("should delete user with the id provided and send notify and force when parameters are passed") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/users/123456") && isMethodDELETE() && containsQueryParams(["notify": "true", "force": "true"])) { _ in
                        HTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.users.delete(userId: "123456", notify: true, force: true) { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to succeed, but it got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("listForEnterprise()") {
                it("should return a list of users of the enterprise") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/users") && isMethodGET() && containsQueryParams(["limit": "100"])) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetEnterpriseUsersOffset-Pagination.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        let iterator = sut.users.listForEnterprise(filterTerm: nil, fields: nil, offset: nil, limit: 100)
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let user = page.entries[0]
                                expect(user).to(beAKindOf(User.self))
                                expect(user.id).to(equal("11111"))
                                expect(user.name).to(equal("Test User"))
                                expect(user.login).to(equal("testuser@example.com"))

                            case let .failure(error):
                                fail("Expected call to succeed, but it got \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should return a list of users of the enterprise using marker pagination") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/users") && isMethodGET() && containsQueryParams(["limit": "100", "usemarker": "true"])) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetEnterpriseUsersMarker-Pagination.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        let iterator = sut.users.listForEnterprise(usemarker: true, limit: 100)
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let user = page.entries[0]
                                expect(user).to(beAKindOf(User.self))
                                expect(user.id).to(equal("11111"))
                                expect(user.name).to(equal("Test User"))
                                expect(user.login).to(equal("testuser@example.com"))

                            case let .failure(error):
                                fail("Expected call to succeed, but it got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("inviteToJoinEnterprise()") {
                it("should make API call to invite a user to an enterprise and return the invite object") {
                    stub(
                        condition: isHost("api.box.com") && isPath("/2.0/invites") && isMethodPOST() && hasJsonBody(["enterprise": ["id": "42500"], "actionable_by": ["login": "freeuser@email.com"]])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "InviteUserToEnterprise.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.users.inviteToJoinEnterprise(login: "freeuser@email.com", enterpriseId: "42500") { result in
                            switch result {
                            case let .success(invitation):
                                expect(invitation).to(beAKindOf(Invite.self))
                                expect(invitation.invitedTo?.id).to(equal("22222"))
                                expect(invitation.actionableBy?.login).to(equal("testuser@example.com"))
                            case let .failure(error):
                                fail("Expected call to succeed, but it got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("moveItemsOwnedByUser()") {
                it("should move items owned by user into another user account and return a the folder where all items where moved") {
                    stub(
                        condition: isHost("api.box.com") && isPath("/2.0/users/1234/folders/0") && isMethodPUT() && hasJsonBody(["owned_by": ["id": "123456"]])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "MoveUserItemsToAnotherUser.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.users.moveItemsOwnedByUser(withID: "1234", toUserWithID: "123456") { result in
                            switch result {
                            case let .success(folder):
                                expect(folder).to(beAKindOf(Folder.self))
                            case let .failure(error):
                                fail("Expected call to succeed, but it got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("changeLogin()") {
                it("should change user login and return the user with the new login") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/users/18180156") && isMethodPUT() && hasJsonBody(["login": "testuser@example.com"])) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "UpdateUserLogin.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.users.changeLogin(userId: "18180156", login: "testuser@example.com") { result in
                            switch result {
                            case let .success(folder):
                                expect(folder).to(beAKindOf(User.self))
                                expect(folder.id).to(equal("11111"))
                                expect(folder.login).to(equal("testuser@example.com"))
                            case let .failure(error):
                                fail("Expected call to succeed, but it got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("listEmailAliases()") {
                it("should retrieves all email aliases for a user and return the iterator with the email aliases of the user ") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/users/123456/email_aliases") && isMethodGET()) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GellAllUserEmailAliases.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.users.listEmailAliases(userId: "123456") { result in
                            switch result {
                            case let .success(aliases):
                                expect(aliases).notTo(beNil())
                                expect(aliases.entries[0].id).to(equal("1234"))
                                expect(aliases.entries[0].email).to(equal("user@email.com"))
                            case let .failure(error):
                                fail("Expected call to succeed, but it got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("createEmailAlias()") {
                it("should Add new email aliases for a user and return the new email alias for the user") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/users/123456/email_aliases") && isMethodPOST() && hasJsonBody(["email": "user@email.com"])) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "AddEmailAlias.json")!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.users.createEmailAlias(userId: "123456", email: "user@email.com") { result in
                            switch result {
                            case let .success(emailAlias):
                                expect(emailAlias).to(beAKindOf(EmailAlias.self))
                                expect(emailAlias.id).to(equal("1234"))
                                expect(emailAlias.email).to(equal("user@email.com"))
                            case let .failure(error):
                                fail("Expected call to succeed, but it got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("deleteEmailAlias()") {
                it("should delete email aliases for a user and get and empty response with 204 HTTP status value") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/users/12/email_aliases/1234567890") && isMethodDELETE()) { _ in
                        HTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.users.deleteEmailAlias(userId: "12", emailAliasId: "1234567890") { result in
                            switch result {
                            case .success():
                                break
                            case let .failure(error):
                                fail("Expected call to succeed, but it got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("rollOutOfEnterprise()") {
                it("should roll out user from enterprise get the updated user") {
                    stub(condition: isHost("api.box.com") && isPath("/2.0/users/12345") && isMethodPUT() && self.testRollOutUserFromEnterpriseBody()) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "UpdateUser.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.users.rollOutOfEnterprise(userId: "12345", notify: true) { result in
                            switch result {
                            case let .success(user):
                                expect(user).toNot(beNil())
                                expect(user).to(beAKindOf(User.self))
                                expect(user.id).to(equal("181216415"))
                                expect(user.name).to(equal("Test User"))
                            case let .failure(error):
                                fail("Expected call to succeed, but it got \(error)")
                            }
                            done()
                        }
                    }
                }
            }
        }
    }

    public static func testRollOutUserFromEnterpriseBody() -> HTTPStubsTestBlock {
        return { request in
            let body = request.ohhttpStubs_httpBody!
            if let jsonBody = try! JSONSerialization.jsonObject(with: body) as? [String: Any] {
                return jsonBody["notify"] as? Bool == true && jsonBody["enterprise"] as? NSNull == NSNull()
            }
            return false
        }
    }
}
