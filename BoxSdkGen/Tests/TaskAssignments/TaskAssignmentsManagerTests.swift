import Foundation
import BoxSdkGen
import XCTest

class TaskAssignmentsManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testCreateUpdateGetDeleteTaskAssignment() async throws {
        let file: FileFull = try await CommonsManager().uploadNewFile()
        let date: Date = try Utils.Dates.dateTimeFromString(dateTime: "2035-01-01T00:00:00Z")
        let task: Task = try await client.tasks.createTask(requestBody: CreateTaskRequestBody(item: CreateTaskRequestBodyItemField(id: file.id, type: CreateTaskRequestBodyItemTypeField.file), action: CreateTaskRequestBodyActionField.review, message: "test message", dueAt: date, completionRule: CreateTaskRequestBodyCompletionRuleField.allAssignees))
        XCTAssertTrue(task.message == "test message")
        XCTAssertTrue(task.item!.id == file.id)
        let currentUser: UserFull = try await client.users.getUserMe()
        let taskAssignment: TaskAssignment = try await client.taskAssignments.createTaskAssignment(requestBody: CreateTaskAssignmentRequestBody(task: CreateTaskAssignmentRequestBodyTaskField(id: task.id!, type: CreateTaskAssignmentRequestBodyTaskTypeField.task), assignTo: CreateTaskAssignmentRequestBodyAssignToField(id: currentUser.id)))
        XCTAssertTrue(taskAssignment.item!.id == file.id)
        XCTAssertTrue(taskAssignment.assignedTo!.id == currentUser.id)
        let taskAssignmentById: TaskAssignment = try await client.taskAssignments.getTaskAssignmentById(taskAssignmentId: taskAssignment.id!)
        XCTAssertTrue(taskAssignmentById.id == taskAssignment.id)
        let taskAssignmentsOnTask: TaskAssignments = try await client.taskAssignments.getTaskAssignments(taskId: task.id!)
        XCTAssertTrue(taskAssignmentsOnTask.totalCount! == 1)
        let updatedTaskAssignment: TaskAssignment = try await client.taskAssignments.updateTaskAssignmentById(taskAssignmentId: taskAssignment.id!, requestBody: UpdateTaskAssignmentByIdRequestBody(message: "updated message", resolutionState: UpdateTaskAssignmentByIdRequestBodyResolutionStateField.approved))
        XCTAssertTrue(updatedTaskAssignment.message == "updated message")
        XCTAssertTrue(Utils.Strings.toString(value: updatedTaskAssignment.resolutionState) == "approved")
        await XCTAssertThrowsErrorAsync(try await client.taskAssignments.deleteTaskAssignmentById(taskAssignmentId: taskAssignment.id!))
        try await client.files.deleteFileById(fileId: file.id)
    }
}
