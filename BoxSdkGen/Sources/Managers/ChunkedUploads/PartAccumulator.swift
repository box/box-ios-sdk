import Foundation

public class PartAccumulator {
    public let lastIndex: Int64

    public let parts: [UploadPart]

    public let fileSize: Int64

    public let uploadPartUrl: String

    public let fileHash: Hash

    public init(lastIndex: Int64, parts: [UploadPart], fileSize: Int64, uploadPartUrl: String, fileHash: Hash) {
        self.lastIndex = lastIndex
        self.parts = parts
        self.fileSize = fileSize
        self.uploadPartUrl = uploadPartUrl
        self.fileHash = fileHash
    }

}
