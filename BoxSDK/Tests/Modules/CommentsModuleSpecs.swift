//
//  CommentsModuleSpecs.swift
//  BoxSDK-iOS
//
//  Created by Cary Cheng on 5/31/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class CommentsModuleSpecs: QuickSpec {

    override class func spec() {
        var sut: BoxClient!

        describe("Comments Module") {
            beforeEach {
                sut = BoxSDK.getClient(token: "")
            }

            afterEach {
                HTTPStubs.removeAllStubs()
            }

            describe("create()") {

                it("should make API call to create comment and produce comment response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/comments")
                            && isMethodPOST()
                            && hasJsonBody([
                                "item": [
                                    "type": "file",
                                    "id": "12345"
                                ],
                                "message": "This is a comment."
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "CreateComment.json")!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.comments.create(itemId: "12345", itemType: "file", message: "This is a comment.") { result in
                            switch result {
                            case let .success(comment):
                                expect(comment).toNot(beNil())
                                expect(comment).to(beAKindOf(Comment.self))
                                expect(comment.id).to(equal("12345"))
                                expect(comment.message).to(equal("This is a comment."))
                                expect(comment.type).to(equal("comment"))
                            case let .failure(error):
                                fail("Expected call to create to succeed, but it failed: \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should make API call to create comment with a tagged message and produce comment response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/comments")
                            && isMethodPOST()
                            && hasJsonBody([
                                "item": [
                                    "type": "file",
                                    "id": "12345"
                                ],
                                "tagged_message": "This is a comment for @[11111:Test User]."
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "CreateTaggedComment.json")!,
                            statusCode: 201, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.comments.create(itemId: "12345", itemType: "file", message: "This is a comment for @[11111:Test User].") { result in
                            switch result {
                            case let .success(comment):
                                expect(comment).toNot(beNil())
                                expect(comment).to(beAKindOf(Comment.self))
                                expect(comment.id).to(equal("12345"))
                                expect(comment.message).to(equal("This is a comment for @[11111:Test User]."))
                                expect(comment.type).to(equal("comment"))
                            case let .failure(error):
                                fail("Expected call to createComment to succeed, but it failed: \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("get()") {

                it("should make API call to get comment and produce comment response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/comments/12345")
                            && isMethodGET()
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "GetComment.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.comments.get(commentId: "12345") { result in
                            switch result {
                            case let .success(comment):
                                expect(comment).toNot(beNil())
                                expect(comment).to(beAKindOf(Comment.self))
                                expect(comment.id).to(equal("12345"))
                                expect(comment.type).to(equal("comment"))
                            case let .failure(error):
                                fail("Expected call to get to succeed, but it failed: \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("update()") {

                it("should make API call to update comment and produce comment response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/comments/12345")
                            && isMethodPUT()
                            && hasJsonBody([
                                "message": "This is an updated comment."
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "UpdateCommentInfo.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.comments.update(commentId: "12345", message: "This is an updated comment.") { result in
                            switch result {
                            case let .success(comment):
                                expect(comment).toNot(beNil())
                                expect(comment).to(beAKindOf(Comment.self))
                                expect(comment.id).to(equal("12345"))
                                expect(comment.type).to(equal("comment"))
                                expect(comment.message).to(equal("This is an updated comment."))
                            case let .failure(error):
                                fail("Expected call to update to succeed, but it failed: \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should make API call to update comment with a tagged message and produce comment response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/comments/12345")
                            && isMethodPUT()
                            && hasJsonBody([
                                "tagged_message": "This is an updated comment for @[11111:Test User]."
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "UpdateTaggedComment.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.comments.update(commentId: "12345", message: "This is an updated comment for @[11111:Test User].") { result in
                            switch result {
                            case let .success(comment):
                                expect(comment).toNot(beNil())
                                expect(comment).to(beAKindOf(Comment.self))
                                expect(comment.id).to(equal("12345"))
                                expect(comment.type).to(equal("comment"))
                                expect(comment.message).to(equal("This is an updated comment for @[11111:Test User]."))
                            case let .failure(error):
                                fail("Expected call to update to succeed, but it failed: \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            describe("delete()") {
                it("should make API call to delete comment and produce comment response when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/comments/12345")
                            && isMethodDELETE()
                    ) { _ in
                        HTTPStubsResponse(data: Data(), statusCode: 204, headers: [:])
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        sut.comments.delete(commentId: "12345") { result in
                            if case let .failure(error) = result {
                                fail("Expected call to delete to suceed, but it failed: \(error)")
                            }
                            done()
                        }
                    }
                }
            }
        }
    }
}
