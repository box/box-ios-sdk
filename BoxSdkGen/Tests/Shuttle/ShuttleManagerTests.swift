import Foundation
import BoxSdkGen
import XCTest

class ShuttleManagerTests: RetryableTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClientWithUserSubject(userId: Utils.getEnvironmentVariable(name: "USER_ID"))
    }

    public func testCreateGetUpdateListDeleteShuttleSystemV2026R0() async throws {
        await runWithRetryAsync {
            let systemName: String = Utils.getUUID()
            let createdSystem: ShuttleSystemV2026R0 = try await client.shuttle.createShuttleSystemV2026R0(requestBody: ShuttleSystemCreateRequestV2026R0(name: systemName, systemType: ShuttleSystemCreateRequestV2026R0SystemTypeField.windows))
            XCTAssertTrue(createdSystem.name == systemName)
            XCTAssertTrue(createdSystem.systemType == "windows")
            XCTAssertTrue(Utils.Strings.toString(value: createdSystem.type) == "shuttle_system")
            let systemFromApi: ShuttleSystemV2026R0 = try await client.shuttle.getShuttleSystemByIdV2026R0(shuttleSystemId: createdSystem.id)
            XCTAssertTrue(systemFromApi.id == createdSystem.id)
            XCTAssertTrue(systemFromApi.name == systemName)
            let updatedSystemName: String = Utils.getUUID()
            let updatedSystem: ShuttleSystemV2026R0 = try await client.shuttle.updateShuttleSystemByIdV2026R0(shuttleSystemId: createdSystem.id, requestBody: ShuttleSystemUpdateRequestV2026R0(name: updatedSystemName))
            XCTAssertTrue(updatedSystem.name == updatedSystemName)
            let systems: ShuttleSystemsV2026R0 = try await client.shuttle.getShuttleSystemsV2026R0()
            XCTAssertTrue(systems.entries.count > 0)
            let credentials: ShuttleAgentCredentialsV2026R0 = try await client.shuttle.createShuttleSystemIssueRegistrationTokenV2026R0(shuttleSystemId: createdSystem.id)
            XCTAssertTrue(credentials.registrationToken != "")
            try await client.shuttle.deleteShuttleSystemByIdV2026R0(shuttleSystemId: createdSystem.id)
            await XCTAssertThrowsErrorAsync(try await client.shuttle.getShuttleSystemByIdV2026R0(shuttleSystemId: createdSystem.id))
        }
    }

    public func testShuttleJobsWithNonExistentIdV2026R0() async throws {
        await runWithRetryAsync {
            let resourceId: String = "123456"
            let jobs: ShuttleJobsV2026R0 = try await client.shuttle.getShuttleJobsV2026R0()
            XCTAssertTrue(jobs.entries.count >= 0)
            await XCTAssertThrowsErrorAsync(try await client.shuttle.createShuttleJobV2026R0(requestBody: ShuttleJobCreateRequestV2026R0(name: Utils.getUUID(), jobType: ShuttleJobCreateRequestV2026R0JobTypeField.transfer, sourceSystemId: resourceId)))
            await XCTAssertThrowsErrorAsync(try await client.shuttle.getShuttleJobByIdV2026R0(shuttleJobId: resourceId))
            await XCTAssertThrowsErrorAsync(try await client.shuttle.updateShuttleJobByIdV2026R0(shuttleJobId: resourceId, requestBody: ShuttleJobUpdateRequestV2026R0(name: Utils.getUUID())))
            await XCTAssertThrowsErrorAsync(try await client.shuttle.deleteShuttleJobByIdV2026R0(shuttleJobId: resourceId))
            await XCTAssertThrowsErrorAsync(try await client.shuttle.createShuttleJobStartV2026R0(shuttleJobId: resourceId))
            await XCTAssertThrowsErrorAsync(try await client.shuttle.createShuttleJobStopV2026R0(shuttleJobId: resourceId))
            await XCTAssertThrowsErrorAsync(try await client.shuttle.createShuttleJobPrepareMigrationV2026R0(shuttleJobId: resourceId))
        }
    }

    public func testShuttleRunsWithNonExistentIdV2026R0() async throws {
        await runWithRetryAsync {
            let resourceId: String = "123456"
            let runs: ShuttleRunsV2026R0 = try await client.shuttle.getShuttleRunsV2026R0(queryParams: GetShuttleRunsV2026R0QueryParams(jobId: resourceId))
            XCTAssertTrue(runs.entries.count >= 0)
            await XCTAssertThrowsErrorAsync(try await client.shuttle.getShuttleRunByIdV2026R0(shuttleRunId: resourceId))
        }
    }

    public func testShuttleMappingsWithNonExistentIdV2026R0() async throws {
        await runWithRetryAsync {
            let resourceId: String = "123456"
            await XCTAssertThrowsErrorAsync(try await client.shuttle.getShuttlePathMappingsV2026R0(queryParams: GetShuttlePathMappingsV2026R0QueryParams(jobId: resourceId)))
            await XCTAssertThrowsErrorAsync(try await client.shuttle.getShuttlePathMappingByIdV2026R0(shuttlePathMappingId: resourceId))
            await XCTAssertThrowsErrorAsync(try await client.shuttle.updateShuttlePathMappingByIdV2026R0(shuttlePathMappingId: resourceId, requestBody: ShuttlePathMappingUpdateRequestV2026R0(isPathSkipped: true)))
            await XCTAssertThrowsErrorAsync(try await client.shuttle.deleteShuttlePathMappingByIdV2026R0(shuttlePathMappingId: resourceId))
            await XCTAssertThrowsErrorAsync(try await client.shuttle.createShuttlePathMappingImportV2026R0(requestBody: ShuttlePathMappingImportCreateRequestV2026R0(jobId: resourceId, fileId: resourceId)))
            await XCTAssertThrowsErrorAsync(try await client.shuttle.getShuttleSubjectMappingsV2026R0(queryParams: GetShuttleSubjectMappingsV2026R0QueryParams(jobId: resourceId)))
            await XCTAssertThrowsErrorAsync(try await client.shuttle.createShuttleSubjectMappingV2026R0(requestBody: ShuttleSubjectMappingCreateRequestV2026R0(jobId: resourceId, discoveredSubjectId: resourceId)))
            await XCTAssertThrowsErrorAsync(try await client.shuttle.getShuttleSubjectMappingByIdV2026R0(shuttleSubjectMappingId: resourceId))
            await XCTAssertThrowsErrorAsync(try await client.shuttle.updateShuttleSubjectMappingByIdV2026R0(shuttleSubjectMappingId: resourceId, requestBody: ShuttleSubjectMappingUpdateRequestV2026R0(isSubjectSkipped: true)))
            await XCTAssertThrowsErrorAsync(try await client.shuttle.deleteShuttleSubjectMappingByIdV2026R0(shuttleSubjectMappingId: resourceId))
            await XCTAssertThrowsErrorAsync(try await client.shuttle.createShuttleSubjectMappingImportV2026R0(requestBody: ShuttleSubjectMappingImportCreateRequestV2026R0(jobId: resourceId, fileId: resourceId)))
            await XCTAssertThrowsErrorAsync(try await client.shuttle.getShuttleDiscoveredSubjectsV2026R0(queryParams: GetShuttleDiscoveredSubjectsV2026R0QueryParams(jobId: resourceId)))
            await XCTAssertThrowsErrorAsync(try await client.shuttle.getShuttlePathEntriesV2026R0(queryParams: GetShuttlePathEntriesV2026R0QueryParams(jobId: resourceId, side: GetShuttlePathEntriesV2026R0QueryParamsSideField.source)))
            await XCTAssertThrowsErrorAsync(try await client.shuttle.getShuttleMappingErrorsV2026R0(queryParams: GetShuttleMappingErrorsV2026R0QueryParams(jobId: resourceId)))
        }
    }

    public func testShuttleReportsWithNonExistentIdV2026R0() async throws {
        await runWithRetryAsync {
            let resourceId: String = "123456"
            await XCTAssertThrowsErrorAsync(try await client.shuttle.getShuttleReportsV2026R0(queryParams: GetShuttleReportsV2026R0QueryParams(runId: resourceId)))
            await XCTAssertThrowsErrorAsync(try await client.shuttle.createShuttleReportV2026R0(requestBody: ShuttleReportCreateRequestV2026R0(runId: resourceId, format: ShuttleReportCreateRequestV2026R0FormatField.csv, sections: ["summary"])))
            await XCTAssertThrowsErrorAsync(try await client.shuttle.getShuttleReportByIdV2026R0(shuttleReportId: resourceId))
        }
    }

    public func testShuttleJobSchedulesWithNonExistentIdV2026R0() async throws {
        await runWithRetryAsync {
            let resourceId: String = "123456"
            await XCTAssertThrowsErrorAsync(try await client.shuttle.getShuttleJobSchedulesV2026R0(queryParams: GetShuttleJobSchedulesV2026R0QueryParams(jobId: resourceId)))
            await XCTAssertThrowsErrorAsync(try await client.shuttle.getShuttleJobScheduleByIdV2026R0(shuttleJobScheduleId: resourceId))
            await XCTAssertThrowsErrorAsync(try await client.shuttle.updateShuttleJobScheduleByIdV2026R0(shuttleJobScheduleId: resourceId, requestBody: ShuttleJobScheduleUpdateRequestV2026R0(runMode: ShuttleJobScheduleUpdateRequestV2026R0RunModeField.simulation)))
            await XCTAssertThrowsErrorAsync(try await client.shuttle.deleteShuttleJobScheduleByIdV2026R0(shuttleJobScheduleId: resourceId))
        }
    }
}
