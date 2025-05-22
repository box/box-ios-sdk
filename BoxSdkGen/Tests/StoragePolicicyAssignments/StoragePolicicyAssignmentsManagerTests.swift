import Foundation
import BoxSdkGen
import XCTest

class StoragePolicicyAssignmentsManagerTests: XCTestCase {
    var adminUserId: String!

    override func setUp() async throws {
        adminUserId = Utils.getEnvironmentVariable(name: "USER_ID")
    }

    public func getOrCreateStoragePolicyAssignment(client: BoxClient, policyId: String, userId: String) async throws -> StoragePolicyAssignment {
        let storagePolicyAssignments: StoragePolicyAssignments = try await client.storagePolicyAssignments.getStoragePolicyAssignments(queryParams: GetStoragePolicyAssignmentsQueryParams(resolvedForType: GetStoragePolicyAssignmentsQueryParamsResolvedForTypeField.user, resolvedForId: userId))
        if storagePolicyAssignments.entries!.count > 0 {
            if Utils.Strings.toString(value: storagePolicyAssignments.entries![0].assignedTo!.type) == "user" {
                return storagePolicyAssignments.entries![0]
            }

        }

        let storagePolicyAssignment: StoragePolicyAssignment = try await client.storagePolicyAssignments.createStoragePolicyAssignment(requestBody: CreateStoragePolicyAssignmentRequestBody(storagePolicy: CreateStoragePolicyAssignmentRequestBodyStoragePolicyField(id: policyId), assignedTo: CreateStoragePolicyAssignmentRequestBodyAssignedToField(type: CreateStoragePolicyAssignmentRequestBodyAssignedToTypeField.user, id: userId)))
        return storagePolicyAssignment
    }

    public func testGetStoragePolicyAssignments() async throws {
        let client: BoxClient = CommonsManager().getDefaultClientWithUserSubject(userId: adminUserId)
        let userName: String = Utils.getUUID()
        let newUser: UserFull = try await client.users.createUser(requestBody: CreateUserRequestBody(name: userName, isPlatformAccessOnly: true))
        let storagePolicies: StoragePolicies = try await client.storagePolicies.getStoragePolicies()
        let storagePolicy1: StoragePolicy = storagePolicies.entries![0]
        let storagePolicy2: StoragePolicy = storagePolicies.entries![1]
        let storagePolicyAssignment: StoragePolicyAssignment = try await getOrCreateStoragePolicyAssignment(client: client, policyId: storagePolicy1.id, userId: newUser.id)
        XCTAssertTrue(Utils.Strings.toString(value: storagePolicyAssignment.type) == "storage_policy_assignment")
        XCTAssertTrue(Utils.Strings.toString(value: storagePolicyAssignment.assignedTo!.type) == "user")
        XCTAssertTrue(storagePolicyAssignment.assignedTo!.id == newUser.id)
        let getStoragePolicyAssignment: StoragePolicyAssignment = try await client.storagePolicyAssignments.getStoragePolicyAssignmentById(storagePolicyAssignmentId: storagePolicyAssignment.id)
        XCTAssertTrue(getStoragePolicyAssignment.id == storagePolicyAssignment.id)
        let updatedStoragePolicyAssignment: StoragePolicyAssignment = try await client.storagePolicyAssignments.updateStoragePolicyAssignmentById(storagePolicyAssignmentId: storagePolicyAssignment.id, requestBody: UpdateStoragePolicyAssignmentByIdRequestBody(storagePolicy: UpdateStoragePolicyAssignmentByIdRequestBodyStoragePolicyField(id: storagePolicy2.id)))
        XCTAssertTrue(updatedStoragePolicyAssignment.storagePolicy!.id == storagePolicy2.id)
        try await client.storagePolicyAssignments.deleteStoragePolicyAssignmentById(storagePolicyAssignmentId: storagePolicyAssignment.id)
        try await client.users.deleteUserById(userId: newUser.id)
    }
}
