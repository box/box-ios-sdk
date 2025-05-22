import Foundation
import BoxSdkGen
import XCTest

class CommentsManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testComments() async throws {
        let fileSize: Int = 256
        let fileName: String = Utils.getUUID()
        let fileByteStream: InputStream = Utils.generateByteStream(size: fileSize)
        let parentId: String = "0"
        let uploadedFiles: Files = try await client.uploads.uploadFile(requestBody: UploadFileRequestBody(attributes: UploadFileRequestBodyAttributesField(name: fileName, parent: UploadFileRequestBodyAttributesParentField(id: parentId)), file: fileByteStream))
        let fileId: String = uploadedFiles.entries![0].id
        let comments: Comments = try await client.comments.getFileComments(fileId: fileId)
        XCTAssertTrue(comments.totalCount == 0)
        let message: String = "Hello there!"
        let newComment: CommentFull = try await client.comments.createComment(requestBody: CreateCommentRequestBody(message: message, item: CreateCommentRequestBodyItemField(id: fileId, type: CreateCommentRequestBodyItemTypeField.file)))
        XCTAssertTrue(newComment.message == message)
        XCTAssertTrue(newComment.isReplyComment == false)
        XCTAssertTrue(newComment.item!.id == fileId)
        let newReplyComment: CommentFull = try await client.comments.createComment(requestBody: CreateCommentRequestBody(message: message, item: CreateCommentRequestBodyItemField(id: newComment.id!, type: CreateCommentRequestBodyItemTypeField.comment)))
        XCTAssertTrue(newReplyComment.message == message)
        XCTAssertTrue(newReplyComment.isReplyComment == true)
        let newMessage: String = "Hi!"
        try await client.comments.updateCommentById(commentId: newReplyComment.id!, requestBody: UpdateCommentByIdRequestBody(message: newMessage))
        let newComments: Comments = try await client.comments.getFileComments(fileId: fileId)
        XCTAssertTrue(newComments.totalCount == 2)
        XCTAssertTrue(newComments.entries![1].message == newMessage)
        let receivedComment: CommentFull = try await client.comments.getCommentById(commentId: newComment.id!)
        XCTAssertTrue(receivedComment.message! == newComment.message!)
        try await client.comments.deleteCommentById(commentId: newComment.id!)
        await XCTAssertThrowsErrorAsync(try await client.comments.getCommentById(commentId: newComment.id!))
        try await client.files.deleteFileById(fileId: fileId)
    }
}
