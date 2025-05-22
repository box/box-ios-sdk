import Foundation
import BoxSdkGen
import XCTest

class LegalHoldPolicyAssignmentsManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testLegalHoldPolicyAssignments() async throws {
        let legalHoldPolicyName: String = Utils.getUUID()
        let legalHoldDescription: String = "test description"
        let legalHoldPolicy: LegalHoldPolicy = try await client.legalHoldPolicies.createLegalHoldPolicy(requestBody: CreateLegalHoldPolicyRequestBody(policyName: legalHoldPolicyName, description: legalHoldDescription, isOngoing: true))
        let legalHoldPolicyId: String = legalHoldPolicy.id
        let file: FileFull = try await CommonsManager().uploadNewFile()
        let fileId: String = file.id
        let legalHoldPolicyAssignment: LegalHoldPolicyAssignment = try await client.legalHoldPolicyAssignments.createLegalHoldPolicyAssignment(requestBody: CreateLegalHoldPolicyAssignmentRequestBody(policyId: legalHoldPolicyId, assignTo: CreateLegalHoldPolicyAssignmentRequestBodyAssignToField(type: CreateLegalHoldPolicyAssignmentRequestBodyAssignToTypeField.file, id: fileId)))
        XCTAssertTrue(Utils.Strings.toString(value: legalHoldPolicyAssignment.legalHoldPolicy!.type) == "legal_hold_policy")
        let legalHoldPolicyAssignmentId: String = legalHoldPolicyAssignment.id!
        let legalHoldPolicyAssignmentFromApi: LegalHoldPolicyAssignment = try await client.legalHoldPolicyAssignments.getLegalHoldPolicyAssignmentById(legalHoldPolicyAssignmentId: legalHoldPolicyAssignmentId)
        XCTAssertTrue(legalHoldPolicyAssignmentFromApi.id! == legalHoldPolicyAssignmentId)
        let legalPolicyAssignments: LegalHoldPolicyAssignments = try await client.legalHoldPolicyAssignments.getLegalHoldPolicyAssignments(queryParams: GetLegalHoldPolicyAssignmentsQueryParams(policyId: legalHoldPolicyId))
        XCTAssertTrue(legalPolicyAssignments.entries!.count == 1)
        let filesOnHold: FilesOnHold = try await client.legalHoldPolicyAssignments.getLegalHoldPolicyAssignmentFileOnHold(legalHoldPolicyAssignmentId: legalHoldPolicyAssignmentId)
        XCTAssertTrue(filesOnHold.entries!.count == 1)
        XCTAssertTrue(filesOnHold.entries![0].id == fileId)
        try await client.legalHoldPolicyAssignments.deleteLegalHoldPolicyAssignmentById(legalHoldPolicyAssignmentId: legalHoldPolicyAssignmentId)
        await XCTAssertThrowsErrorAsync(try await client.legalHoldPolicyAssignments.deleteLegalHoldPolicyAssignmentById(legalHoldPolicyAssignmentId: legalHoldPolicyAssignmentId))
        try await client.files.deleteFileById(fileId: fileId)
        do {
            try await client.legalHoldPolicies.deleteLegalHoldPolicyById(legalHoldPolicyId: legalHoldPolicyId)
        } catch {
            print("\("Could not delete Legal Policy with id: ")\(legalHoldPolicyId)")
        }

    }
}
