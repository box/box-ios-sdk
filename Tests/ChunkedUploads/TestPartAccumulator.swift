import Foundation
import BoxSdkGen
import XCTest

public class TestPartAccumulator {
    public let lastIndex: Int

    public let parts: [UploadPart]

    public let fileSize: Int64

    public let fileHash: Hash

    public let uploadPartUrl: String

    public let uploadSessionId: String

    public init(lastIndex: Int, parts: [UploadPart], fileSize: Int64, fileHash: Hash, uploadPartUrl: String = "", uploadSessionId: String = "") {
        self.lastIndex = lastIndex
        self.parts = parts
        self.fileSize = fileSize
        self.fileHash = fileHash
        self.uploadPartUrl = uploadPartUrl
        self.uploadSessionId = uploadSessionId
    }

}
