import Foundation
import BoxSdkGen
import XCTest

class ChunkedUploadsManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func reducerById(acc: TestPartAccumulator, chunk: InputStream) async throws -> TestPartAccumulator {
        let lastIndex: Int = acc.lastIndex
        let parts: [UploadPart] = acc.parts
        let chunkBuffer: Data = Utils.readByteStream(byteStream: chunk)
        let hash: Hash = Hash(algorithm: HashName.sha1)
        hash.updateHash(data: chunkBuffer)
        let sha1: String = await hash.digestHash(encoding: "base64")
        let digest: String = "\("sha=")\(sha1)"
        let chunkSize: Int = Utils.bufferLength(buffer: chunkBuffer)
        let bytesStart: Int = lastIndex + 1
        let bytesEnd: Int = lastIndex + chunkSize
        let contentRange: String = "\("bytes ")\(Utils.Strings.toString(value: bytesStart)!)\("-")\(Utils.Strings.toString(value: bytesEnd)!)\("/")\(Utils.Strings.toString(value: acc.fileSize)!)"
        let uploadedPart: UploadedPart = try await client.chunkedUploads.uploadFilePart(uploadSessionId: acc.uploadSessionId, requestBody: Utils.generateByteStreamFromBuffer(buffer: chunkBuffer), headers: UploadFilePartHeaders(digest: digest, contentRange: contentRange))
        let part: UploadPart = uploadedPart.part!
        let partSha1: String = Utils.Strings.hextToBase64(value: part.sha1!)
        assert(partSha1 == sha1)
        assert(part.size! == chunkSize)
        assert(part.offset! == bytesStart)
        acc.fileHash.updateHash(data: chunkBuffer)
        return TestPartAccumulator(lastIndex: bytesEnd, parts: parts + [part], fileSize: acc.fileSize, fileHash: acc.fileHash, uploadSessionId: acc.uploadSessionId)
    }

    public func testChunkedManualProcessById() async throws {
        let fileSize: Int = 20 * 1024 * 1024
        let fileByteStream: InputStream = Utils.generateByteStream(size: fileSize)
        let fileName: String = Utils.getUUID()
        let parentFolderId: String = "0"
        let uploadSession: UploadSession = try await client.chunkedUploads.createFileUploadSession(requestBody: CreateFileUploadSessionRequestBody(folderId: parentFolderId, fileSize: Int64(fileSize), fileName: fileName))
        let uploadSessionId: String = uploadSession.id!
        let partSize: Int64 = uploadSession.partSize!
        let totalParts: Int = uploadSession.totalParts!
        XCTAssertTrue(partSize * Int64(totalParts) >= fileSize)
        XCTAssertTrue(uploadSession.numPartsProcessed == 0)
        let fileHash: Hash = Hash(algorithm: HashName.sha1)
        let chunksIterator: StreamSequence = Utils.iterateChunks(stream: fileByteStream, chunkSize: partSize, fileSize: Int64(fileSize))
        let results: TestPartAccumulator = try await Utils.reduceIterator(iterator: chunksIterator, reducer: reducerById, initialValue: TestPartAccumulator(lastIndex: -1, parts: [], fileSize: Int64(fileSize), fileHash: fileHash, uploadSessionId: uploadSessionId))
        let parts: [UploadPart] = results.parts
        let processedSessionParts: UploadParts = try await client.chunkedUploads.getFileUploadSessionParts(uploadSessionId: uploadSessionId)
        XCTAssertTrue(processedSessionParts.totalCount! == totalParts)
        let processedSession: UploadSession = try await client.chunkedUploads.getFileUploadSessionById(uploadSessionId: uploadSessionId)
        XCTAssertTrue(processedSession.id! == uploadSessionId)
        let sha1: String = await fileHash.digestHash(encoding: "base64")
        let digest: String = "\("sha=")\(sha1)"
        let committedSession: Files? = try await client.chunkedUploads.createFileUploadSessionCommit(uploadSessionId: uploadSessionId, requestBody: CreateFileUploadSessionCommitRequestBody(parts: parts), headers: CreateFileUploadSessionCommitHeaders(digest: digest))
        XCTAssertTrue(committedSession!.entries![0].name! == fileName)
        try await client.chunkedUploads.deleteFileUploadSessionById(uploadSessionId: uploadSessionId)
    }

    public func reducerByUrl(acc: TestPartAccumulator, chunk: InputStream) async throws -> TestPartAccumulator {
        let lastIndex: Int = acc.lastIndex
        let parts: [UploadPart] = acc.parts
        let chunkBuffer: Data = Utils.readByteStream(byteStream: chunk)
        let hash: Hash = Hash(algorithm: HashName.sha1)
        hash.updateHash(data: chunkBuffer)
        let sha1: String = await hash.digestHash(encoding: "base64")
        let digest: String = "\("sha=")\(sha1)"
        let chunkSize: Int = Utils.bufferLength(buffer: chunkBuffer)
        let bytesStart: Int = lastIndex + 1
        let bytesEnd: Int = lastIndex + chunkSize
        let contentRange: String = "\("bytes ")\(Utils.Strings.toString(value: bytesStart)!)\("-")\(Utils.Strings.toString(value: bytesEnd)!)\("/")\(Utils.Strings.toString(value: acc.fileSize)!)"
        let uploadedPart: UploadedPart = try await client.chunkedUploads.uploadFilePartByUrl(url: acc.uploadPartUrl, requestBody: Utils.generateByteStreamFromBuffer(buffer: chunkBuffer), headers: UploadFilePartByUrlHeaders(digest: digest, contentRange: contentRange))
        let part: UploadPart = uploadedPart.part!
        let partSha1: String = Utils.Strings.hextToBase64(value: part.sha1!)
        assert(partSha1 == sha1)
        assert(part.size! == chunkSize)
        assert(part.offset! == bytesStart)
        acc.fileHash.updateHash(data: chunkBuffer)
        return TestPartAccumulator(lastIndex: bytesEnd, parts: parts + [part], fileSize: acc.fileSize, fileHash: acc.fileHash, uploadPartUrl: acc.uploadPartUrl)
    }

    public func testChunkedManualProcessByUrl() async throws {
        let fileSize: Int = 20 * 1024 * 1024
        let fileByteStream: InputStream = Utils.generateByteStream(size: fileSize)
        let fileName: String = Utils.getUUID()
        let parentFolderId: String = "0"
        let uploadSession: UploadSession = try await client.chunkedUploads.createFileUploadSession(requestBody: CreateFileUploadSessionRequestBody(folderId: parentFolderId, fileSize: Int64(fileSize), fileName: fileName))
        let uploadPartUrl: String = uploadSession.sessionEndpoints!.uploadPart!
        let commitUrl: String = uploadSession.sessionEndpoints!.commit!
        let listPartsUrl: String = uploadSession.sessionEndpoints!.listParts!
        let statusUrl: String = uploadSession.sessionEndpoints!.status!
        let abortUrl: String = uploadSession.sessionEndpoints!.abort!
        let uploadSessionId: String = uploadSession.id!
        let partSize: Int64 = uploadSession.partSize!
        let totalParts: Int = uploadSession.totalParts!
        XCTAssertTrue(partSize * Int64(totalParts) >= fileSize)
        XCTAssertTrue(uploadSession.numPartsProcessed == 0)
        let fileHash: Hash = Hash(algorithm: HashName.sha1)
        let chunksIterator: StreamSequence = Utils.iterateChunks(stream: fileByteStream, chunkSize: partSize, fileSize: Int64(fileSize))
        let results: TestPartAccumulator = try await Utils.reduceIterator(iterator: chunksIterator, reducer: reducerByUrl, initialValue: TestPartAccumulator(lastIndex: -1, parts: [], fileSize: Int64(fileSize), fileHash: fileHash, uploadPartUrl: uploadPartUrl))
        let parts: [UploadPart] = results.parts
        let processedSessionParts: UploadParts = try await client.chunkedUploads.getFileUploadSessionPartsByUrl(url: listPartsUrl)
        XCTAssertTrue(processedSessionParts.totalCount! == totalParts)
        let processedSession: UploadSession = try await client.chunkedUploads.getFileUploadSessionByUrl(url: statusUrl)
        XCTAssertTrue(processedSession.id! == uploadSessionId)
        let sha1: String = await fileHash.digestHash(encoding: "base64")
        let digest: String = "\("sha=")\(sha1)"
        let committedSession: Files? = try await client.chunkedUploads.createFileUploadSessionCommitByUrl(url: commitUrl, requestBody: CreateFileUploadSessionCommitByUrlRequestBody(parts: parts), headers: CreateFileUploadSessionCommitByUrlHeaders(digest: digest))
        XCTAssertTrue(committedSession!.entries![0].name! == fileName)
        try await client.chunkedUploads.deleteFileUploadSessionByUrl(url: abortUrl)
    }

    public func testChunkedUploadConvenienceMethod() async throws {
        let fileSize: Int = 20 * 1024 * 1024
        let fileByteStream: InputStream = Utils.generateByteStream(size: fileSize)
        let fileName: String = Utils.getUUID()
        let parentFolderId: String = "0"
        let uploadedFile: File = try await client.chunkedUploads.uploadBigFile(file: fileByteStream, fileName: fileName, fileSize: Int64(fileSize), parentFolderId: parentFolderId)
        XCTAssertTrue(uploadedFile.name! == fileName)
        XCTAssertTrue(uploadedFile.size! == fileSize)
        XCTAssertTrue(uploadedFile.parent!.id == parentFolderId)
        try await client.files.deleteFileById(fileId: uploadedFile.id)
    }
}
