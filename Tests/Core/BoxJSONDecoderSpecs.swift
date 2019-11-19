//
//  BoxJSONDecoderSpecs.swift
//  BoxSDK
//
//  Created by Matthew Willer on 10/8/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class BoxJSONDecoderSpecs: QuickSpec {

    override func spec() {
        describe("BoxJSONDecoder") {

            describe("optionalDecode<BoxModel>()") {
                it("should deserialize simple model from JSON when key is present with correct object value") {
                    let json: [String: Any] = ["user": ["type": "user", "id": "12345"]]
                    guard let user: User = try? BoxJSONDecoder.optionalDecode(json: json, forKey: "user") else {
                        fail("Expected user object to be deserialized when present")
                        return
                    }

                    expect(user.id).to(equal("12345"))
                }

                it("should return nil when key is present and contains null value") {
                    let json: [String: Any] = ["user": NSNull()]
                    let user: User?
                    do {
                        user = try BoxJSONDecoder.optionalDecode(json: json, forKey: "user")
                    }
                    catch {
                        fail("Decoding failed unexpectedly: \(error)")
                        return
                    }

                    expect(user).to(beNil())
                }

                it("should return nil when key is absent") {
                    let json: [String: Any] = [:]
                    let user: User?
                    do {
                        user = try BoxJSONDecoder.optionalDecode(json: json, forKey: "user")
                    }
                    catch {
                        fail("Decoding failed unexpectedly: \(error)")
                        return
                    }

                    expect(user).to(beNil())
                }

                it("should throw when key is present and contains invalid value") {
                    let json: [String: Any] = ["user": 12345]
                    do {
                        let _: User? = try BoxJSONDecoder.optionalDecode(json: json, forKey: "user")
                        fail("Expected method to throw, but it didn't")
                    }
                    catch {
                        expect(error).to(matchError(BoxCodingError(message: .typeMismatch(key: "user"))))
                    }
                }
            }

            describe("optionalDecodeCollection<BoxModel>()") {
                it("should deserialize model collection from JSON when key is present with correct object values") {
                    let json: [String: Any] = ["users": [
                        ["type": "user", "id": "12345"],
                        ["type": "user", "id": "98765"]
                    ]]
                    guard let users: [User] = try? BoxJSONDecoder.optionalDecodeCollection(json: json, forKey: "users") else {
                        fail("Expected user array to be deserialized when present")
                        return
                    }

                    expect(users[0].id).to(equal("12345"))
                    expect(users[1].id).to(equal("98765"))
                }

                it("should return nil when key is present and contains null value") {
                    let json: [String: Any] = ["users": NSNull()]
                    let users: [User]?
                    do {
                        users = try BoxJSONDecoder.optionalDecodeCollection(json: json, forKey: "users")
                    }
                    catch {
                        fail("Decoding failed unexpectedly: \(error)")
                        return
                    }

                    expect(users).to(beNil())
                }

                it("should return nil when key is absent") {
                    let json: [String: Any] = [:]
                    let users: [User]?
                    do {
                        users = try BoxJSONDecoder.optionalDecodeCollection(json: json, forKey: "users")
                    }
                    catch {
                        fail("Decoding failed unexpectedly: \(error)")
                        return
                    }

                    expect(users).to(beNil())
                }

                it("should throw when key is present and contains invalid value") {
                    let json: [String: Any] = ["users": 12345]
                    do {
                        let _: [User]? = try BoxJSONDecoder.optionalDecodeCollection(json: json, forKey: "users")
                        fail("Expected method to throw, but it didn't")
                    }
                    catch {
                        expect(error).to(matchError(BoxCodingError(message: .typeMismatch(key: "users"))))
                    }
                }
            }

            describe("optionalDecodeEnumCollection<BoxEnum>()") {
                it("should deserialize enum collection from JSON when key is present with correct string values") {
                    let json: [String: Any] = ["sort_fields": ["name", "id", "date"]]
                    guard let sortFields: [FolderItemsOrderBy] = try? BoxJSONDecoder.optionalDecodeEnumCollection(json: json, forKey: "sort_fields") else {
                        fail("Expected enum array to be deserialized when present")
                        return
                    }

                    expect(sortFields[0]).to(equal(.name))
                    expect(sortFields[1]).to(equal(.id))
                    expect(sortFields[2]).to(equal(.date))
                }

                it("should return nil when key is present and contains null value") {
                    let json: [String: Any] = ["sort_fields": NSNull()]
                    let sortFields: [FolderItemsOrderBy]?
                    do {
                        sortFields = try BoxJSONDecoder.optionalDecodeEnumCollection(json: json, forKey: "sort_fields")
                    }
                    catch {
                        fail("Decoding failed unexpectedly: \(error)")
                        return
                    }

                    expect(sortFields).to(beNil())
                }

                it("should return nil when key is absent") {
                    let json: [String: Any] = [:]
                    let sortFields: [FolderItemsOrderBy]?
                    do {
                        sortFields = try BoxJSONDecoder.optionalDecodeEnumCollection(json: json, forKey: "sort_fields")
                    }
                    catch {
                        fail("Decoding failed unexpectedly: \(error)")
                        return
                    }

                    expect(sortFields).to(beNil())
                }

                it("should throw when key is present and contains invalid value") {
                    let json: [String: Any] = ["sort_fields": 12345]
                    do {
                        let _: [FolderItemsOrderBy]? = try BoxJSONDecoder.optionalDecodeEnumCollection(json: json, forKey: "sort_fields")
                        fail("Expected method to throw, but it didn't")
                    }
                    catch {
                        expect(error).to(matchError(BoxCodingError(message: .typeMismatch(key: "sort_fields"))))
                    }
                }
            }

            describe("optionalDecode<generic>()") {
                it("should deserialize generic value from JSON when key is present with correct value type") {
                    let json: [String: Any] = ["description": "my stuff"]
                    guard let description: String = try? BoxJSONDecoder.optionalDecode(json: json, forKey: "description") else {
                        fail("Expected string value to be deserialized when present")
                        return
                    }

                    expect(description).to(equal("my stuff"))
                }

                it("should return nil when key is present and contains null value") {
                    let json: [String: Any] = ["id": NSNull()]
                    let description: String?
                    do {
                        description = try BoxJSONDecoder.optionalDecode(json: json, forKey: "description")
                    }
                    catch {
                        fail("Decoding failed unexpectedly: \(error)")
                        return
                    }

                    expect(description).to(beNil())
                }

                it("should return nil when key is absent") {
                    let json: [String: Any] = [:]
                    let description: String?
                    do {
                        description = try BoxJSONDecoder.optionalDecode(json: json, forKey: "description")
                    }
                    catch {
                        fail("Decoding failed unexpectedly: \(error)")
                        return
                    }

                    expect(description).to(beNil())
                }

                it("should throw when key is present and contains invalid value") {
                    let json: [String: Any] = ["description": 12345]
                    do {
                        let _: String? = try BoxJSONDecoder.optionalDecode(json: json, forKey: "description")
                        fail("Expected method to throw, but it didn't")
                    }
                    catch {
                        expect(error).to(matchError(BoxCodingError(message: .typeMismatch(key: "description"))))
                    }
                }
            }

            describe("optionalDecodeDate()") {
                it("should deserialize date from JSON when key is present with correct string value") {
                    let json: [String: Any] = ["deadline": "2019-10-17T23:59:59-07:00"]
                    guard let deadline: Date = try? BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "deadline") else {
                        fail("Expected string value to be deserialized when present")
                        return
                    }

                    let expectedDate = Date(timeIntervalSince1970: 1_571_381_999) // 2019-10-17T23:59:59-07:00
                    expect(deadline).to(equal(expectedDate))
                }

                it("should return nil when key is present and contains null value") {
                    let json: [String: Any] = ["deadline": NSNull()]
                    let deadline: Date?
                    do {
                        deadline = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "deadline")
                    }
                    catch {
                        fail("Decoding failed unexpectedly: \(error)")
                        return
                    }

                    expect(deadline).to(beNil())
                }

                it("should return nil when key is absent") {
                    let json: [String: Any] = [:]
                    let deadline: Date?
                    do {
                        deadline = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "deadline")
                    }
                    catch {
                        fail("Decoding failed unexpectedly: \(error)")
                        return
                    }

                    expect(deadline).to(beNil())
                }

                it("should throw when key is present and contains invalid value type") {
                    let json: [String: Any] = ["deadline": 12345]
                    do {
                        let _: Date? = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "deadline")
                        fail("Expected method to throw, but it didn't")
                    }
                    catch {
                        expect(error).to(matchError(BoxCodingError(message: .typeMismatch(key: "deadline"))))
                    }
                }

                it("should throw when key is present and contains invalid value format") {
                    let json: [String: Any] = ["deadline": "Tue, 08 Oct 2019 19:52:28 GMT"]
                    do {
                        let _: Date? = try BoxJSONDecoder.optionalDecodeDate(json: json, forKey: "deadline")
                        fail("Expected method to throw, but it didn't")
                    }
                    catch {
                        expect(error).to(matchError(BoxCodingError(message: .invalidValueFormat(key: "deadline"))))
                    }
                }
            }

            describe("optionalDecodeEnum()") {
                it("should deserialize known enum from JSON when key is present with known string value") {
                    let json: [String: Any] = ["status": "active"]
                    guard let status: ItemStatus = try? BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "status") else {
                        fail("Expected string value to be deserialized when present")
                        return
                    }

                    expect(status).to(equal(.active))
                }

                it("should deserialize custom value enum from JSON when key is present with unknown string value") {
                    let json: [String: Any] = ["status": "foobarbaz"]
                    guard let status: ItemStatus = try? BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "status") else {
                        fail("Expected string value to be deserialized when present")
                        return
                    }

                    expect(status).to(equal(.customValue("foobarbaz")))
                }

                it("should return nil when key is present and contains null value") {
                    let json: [String: Any] = ["status": NSNull()]
                    let status: ItemStatus?
                    do {
                        status = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "status")
                    }
                    catch {
                        fail("Decoding failed unexpectedly: \(error)")
                        return
                    }

                    expect(status).to(beNil())
                }

                it("should return nil when key is absent") {
                    let json: [String: Any] = [:]
                    let status: ItemStatus?
                    do {
                        status = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "status")
                    }
                    catch {
                        fail("Decoding failed unexpectedly: \(error)")
                        return
                    }

                    expect(status).to(beNil())
                }

                it("should throw when key is present and contains invalid value type") {
                    let json: [String: Any] = ["status": 12345]
                    do {
                        let _: ItemStatus? = try BoxJSONDecoder.optionalDecodeEnum(json: json, forKey: "status")
                        fail("Expected method to throw, but it didn't")
                    }
                    catch {
                        expect(error).to(matchError(BoxCodingError(message: .typeMismatch(key: "status"))))
                    }
                }
            }

            describe("optionalDecodeURL()") {
                it("should deserialize URL from JSON when key is present with correct string value") {
                    let json: [String: Any] = ["url": "https://example.com/"]
                    guard let url: URL = try? BoxJSONDecoder.optionalDecodeURL(json: json, forKey: "url") else {
                        fail("Expected string value to be deserialized when present")
                        return
                    }

                    expect(url.absoluteString).to(equal("https://example.com/"))
                }

                it("should return nil when key is present and contains null value") {
                    let json: [String: Any] = ["url": NSNull()]
                    let url: URL?
                    do {
                        url = try BoxJSONDecoder.optionalDecodeURL(json: json, forKey: "url")
                    }
                    catch {
                        fail("Decoding failed unexpectedly: \(error)")
                        return
                    }

                    expect(url).to(beNil())
                }

                it("should return nil when key is absent") {
                    let json: [String: Any] = [:]
                    let url: URL?
                    do {
                        url = try BoxJSONDecoder.optionalDecodeURL(json: json, forKey: "url")
                    }
                    catch {
                        fail("Decoding failed unexpectedly: \(error)")
                        return
                    }

                    expect(url).to(beNil())
                }

                it("should throw when key is present and contains invalid value type") {
                    let json: [String: Any] = ["url": 12345]
                    do {
                        let _: URL? = try BoxJSONDecoder.optionalDecodeURL(json: json, forKey: "url")
                        fail("Expected method to throw, but it didn't")
                    }
                    catch {
                        expect(error).to(matchError(BoxCodingError(message: .typeMismatch(key: "url"))))
                    }
                }

                it("should throw when key is present and contains invalid value format") {
                    let json: [String: Any] = ["url": "AOL keyword"]
                    do {
                        let _: URL? = try BoxJSONDecoder.optionalDecodeURL(json: json, forKey: "url")
                        fail("Expected method to throw, but it didn't")
                    }
                    catch {
                        expect(error).to(matchError(BoxCodingError(message: .invalidValueFormat(key: "url"))))
                    }
                }
            }

            describe("decode<BoxModel>()") {
                it("should deserialize simple model from JSON when key is present with correct object value") {
                    let json: [String: Any] = ["user": ["type": "user", "id": "12345"]]
                    let user: User
                    do {
                        user = try BoxJSONDecoder.decode(json: json, forKey: "user")
                    }
                    catch {
                        fail("Expected user object to be deserialized when present, but got error: \(error)")
                        return
                    }

                    expect(user.id).to(equal("12345"))
                }

                it("should throw when key is present and contains null value") {
                    let json: [String: Any] = ["user": NSNull()]
                    do {
                        let _: User = try BoxJSONDecoder.decode(json: json, forKey: "user")
                        fail("Expected method to throw, but it didn't")
                    }
                    catch {
                        expect(error).to(matchError(BoxCodingError(message: .typeMismatch(key: "user"))))
                    }
                }

                it("should throw when key is absent") {
                    let json: [String: Any] = [:]
                    do {
                        let _: User = try BoxJSONDecoder.decode(json: json, forKey: "user")
                        fail("Expected method to throw, but it didn't")
                    }
                    catch {
                        expect(error).to(matchError(BoxCodingError(message: .notPresent(key: "user"))))
                    }
                }

                it("should throw when key is present and contains invalid value") {
                    let json: [String: Any] = ["user": 12345]
                    do {
                        let _: User? = try BoxJSONDecoder.decode(json: json, forKey: "user")
                        fail("Expected method to throw, but it didn't")
                    }
                    catch {
                        expect(error).to(matchError(BoxCodingError(message: .typeMismatch(key: "user"))))
                    }
                }
            }

            describe("decodeCollection()") {
                it("should deserialize model array from JSON when key is present with correct object value") {
                    let json: [String: Any] = ["users": [
                        ["type": "user", "id": "12345"],
                        ["type": "user", "id": "98765"]
                    ]]
                    let users: [User]
                    do {
                        users = try BoxJSONDecoder.decodeCollection(json: json, forKey: "users")
                    }
                    catch {
                        fail("Expected user object to be deserialized when present, but got error: \(error)")
                        return
                    }

                    expect(users[0].id).to(equal("12345"))
                    expect(users[1].id).to(equal("98765"))
                }

                it("should throw when key is present and contains null value") {
                    let json: [String: Any] = ["users": NSNull()]
                    do {
                        let _: [User] = try BoxJSONDecoder.decodeCollection(json: json, forKey: "users")
                        fail("Expected method to throw, but it didn't")
                    }
                    catch {
                        expect(error).to(matchError(BoxCodingError(message: .typeMismatch(key: "users"))))
                    }
                }

                it("should throw when key is absent") {
                    let json: [String: Any] = [:]
                    do {
                        let _: [User] = try BoxJSONDecoder.decodeCollection(json: json, forKey: "users")
                        fail("Expected method to throw, but it didn't")
                    }
                    catch {
                        expect(error).to(matchError(BoxCodingError(message: .notPresent(key: "users"))))
                    }
                }

                it("should throw when key is present and contains invalid value") {
                    let json: [String: Any] = ["users": 12345]
                    do {
                        let _: [User] = try BoxJSONDecoder.decodeCollection(json: json, forKey: "users")
                        fail("Expected method to throw, but it didn't")
                    }
                    catch {
                        expect(error).to(matchError(BoxCodingError(message: .typeMismatch(key: "users"))))
                    }
                }
            }

            describe("decodeDate()") {
                it("should deserialize date from JSON when key is present with correct string value") {
                    let json: [String: Any] = ["deadline": "2019-10-17T23:59:59-07:00"]
                    guard let deadline: Date = try? BoxJSONDecoder.decodeDate(json: json, forKey: "deadline") else {
                        fail("Expected string value to be deserialized when present")
                        return
                    }

                    let expectedDate = Date(timeIntervalSince1970: 1_571_381_999) // 2019-10-17T23:59:59-07:00
                    expect(deadline).to(equal(expectedDate))
                }

                it("should throw when key is present and contains null value") {
                    let json: [String: Any] = ["deadline": NSNull()]
                    do {
                        let _: Date = try BoxJSONDecoder.decodeDate(json: json, forKey: "deadline")
                        fail("Expected method to throw, but it didn't")
                    }
                    catch {
                        expect(error).to(matchError(BoxCodingError(message: .typeMismatch(key: "deadline"))))
                    }
                }

                it("should throw when key is absent") {
                    let json: [String: Any] = [:]
                    do {
                        let _: Date = try BoxJSONDecoder.decodeDate(json: json, forKey: "deadline")
                        fail("Expected method to throw, but it didn't")
                    }
                    catch {
                        expect(error).to(matchError(BoxCodingError(message: .notPresent(key: "deadline"))))
                    }
                }

                it("should throw when key is present and contains invalid value") {
                    let json: [String: Any] = ["deadline": 12345]
                    do {
                        let _: Date = try BoxJSONDecoder.decodeDate(json: json, forKey: "deadline")
                        fail("Expected method to throw, but it didn't")
                    }
                    catch {
                        expect(error).to(matchError(BoxCodingError(message: .typeMismatch(key: "deadline"))))
                    }
                }

                it("should throw when key is present and contains invalid value format") {
                    let json: [String: Any] = ["deadline": "Tue, 08 Oct 2019 19:52:28 GMT"]
                    do {
                        let _: Date = try BoxJSONDecoder.decodeDate(json: json, forKey: "deadline")
                        fail("Expected method to throw, but it didn't")
                    }
                    catch {
                        expect(error).to(matchError(BoxCodingError(message: .invalidValueFormat(key: "deadline"))))
                    }
                }
            }

            describe("decodeEnum()") {
                it("should deserialize known enum from JSON when key is present with known string value") {
                    let json: [String: Any] = ["status": "active"]
                    guard let status: ItemStatus = try? BoxJSONDecoder.decodeEnum(json: json, forKey: "status") else {
                        fail("Expected string value to be deserialized when present")
                        return
                    }

                    expect(status).to(equal(.active))
                }

                it("should deserialize custom value enum from JSON when key is present with unknown string value") {
                    let json: [String: Any] = ["status": "foobarbaz"]
                    guard let status: ItemStatus = try? BoxJSONDecoder.decodeEnum(json: json, forKey: "status") else {
                        fail("Expected string value to be deserialized when present")
                        return
                    }

                    expect(status).to(equal(.customValue("foobarbaz")))
                }

                it("should throw when key is present and contains null value") {
                    let json: [String: Any] = ["status": NSNull()]

                    do {
                        let _: ItemStatus = try BoxJSONDecoder.decodeEnum(json: json, forKey: "status")
                        fail("Expected method to throw, but it didn't")
                    }
                    catch {
                        expect(error).to(matchError(BoxCodingError(message: .typeMismatch(key: "status"))))
                    }
                }

                it("should throw when key is absent") {
                    let json: [String: Any] = [:]
                    do {
                        let _: ItemStatus = try BoxJSONDecoder.decodeEnum(json: json, forKey: "status")
                    }
                    catch {
                        expect(error).to(matchError(BoxCodingError(message: .notPresent(key: "status"))))
                    }
                }

                it("should throw when key is present and contains invalid value type") {
                    let json: [String: Any] = ["status": 12345]
                    do {
                        let _: ItemStatus? = try BoxJSONDecoder.decodeEnum(json: json, forKey: "status")
                        fail("Expected method to throw, but it didn't")
                    }
                    catch {
                        expect(error).to(matchError(BoxCodingError(message: .typeMismatch(key: "status"))))
                    }
                }
            }
        }
    }
}
