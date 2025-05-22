import Foundation
import BoxSdkGen
import XCTest

class TasksManagerTests: XCTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testCreateUpdateGetDeleteTask() async throws {
        let files: Files = try await client.uploads.uploadFile(requestBody: UploadFileRequestBody(attributes: UploadFileRequestBodyAttributesField(name: Utils.getUUID(), parent: UploadFileRequestBodyAttributesParentField(id: "0")), file: Utils.generateByteStream(size: 10)))
        let file: FileFull = files.entries![0]
        let dateTime: Date = try Utils.Dates.dateTimeFromString(dateTime: "2035-01-01T00:00:00Z")
        let task: Task = try await client.tasks.createTask(requestBody: CreateTaskRequestBody(item: CreateTaskRequestBodyItemField(id: file.id, type: CreateTaskRequestBodyItemTypeField.file), action: CreateTaskRequestBodyActionField.review, message: "test message", dueAt: dateTime, completionRule: CreateTaskRequestBodyCompletionRuleField.allAssignees))
        XCTAssertTrue(task.message == "test message")
        XCTAssertTrue(task.item!.id == file.id)
        XCTAssertTrue(Utils.Dates.dateTimeToString(dateTime: task.dueAt!) == Utils.Dates.dateTimeToString(dateTime: dateTime))
        let taskById: Task = try await client.tasks.getTaskById(taskId: task.id!)
        XCTAssertTrue(taskById.id == task.id)
        let taskOnFile: Tasks = try await client.tasks.getFileTasks(fileId: file.id)
        XCTAssertTrue(taskOnFile.totalCount == 1)
        let updatedTask: Task = try await client.tasks.updateTaskById(taskId: task.id!, requestBody: UpdateTaskByIdRequestBody(message: "updated message"))
        XCTAssertTrue(updatedTask.message == "updated message")
        try await client.tasks.deleteTaskById(taskId: task.id!)
        try await client.files.deleteFileById(fileId: file.id)
    }
}
