import Foundation
import BoxSdkGen
import XCTest

public class TestPartPlanAccumulator {
    public let lastIndex: Int

    public let parts: [UploadPartPlan]

    public let fileSize: Int64

    public init(lastIndex: Int, parts: [UploadPartPlan], fileSize: Int64) {
        self.lastIndex = lastIndex
        self.parts = parts
        self.fileSize = fileSize
    }

}
