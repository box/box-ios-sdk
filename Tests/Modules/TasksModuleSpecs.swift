//
//  TasksModuleSpecs.swift
//  BoxSDK
//
//  Created by Daniel Cech on 28/08/2019.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import OHHTTPStubs.NSURLRequest_HTTPBodyTesting
import Quick

class TasksModuleSpecs: QuickSpec {
    var sut: BoxClient!

    override func spec() {
        describe("Tasks Module") {
            beforeEach {
                self.sut = BoxSDK.getClient(token: "")
            }

            afterEach {
                OHHTTPStubs.removeAllStubs()
            }

            describe("get()") {

                it("should make API call to get particular task when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/tasks/11111")
                            && isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetTask.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.tasks.get(taskId: "11111") { result in
                            switch result {
                            case let .success(task):
                                expect(task).to(beAKindOf(Task.self))
                                expect(task.id).to(equal("11111"))
                                expect(task.dueAt?.iso8601).to(equal("2014-04-03T18:09:43Z"))
                                expect(task.action).to(equal(.review))
                                expect(task.message).to(equal("Please review."))

                                guard
                                    let item = task.item
                                else {
                                    fail("Task item is not present")
                                    done()
                                    return
                                }

                                guard case let .file(fileItem) = item else {
                                    fail("Task item is not file")
                                    done()
                                    return
                                }

                                expect(fileItem).to(beAKindOf(File.self))
                                expect(fileItem.id).to(equal("22222"))
                                expect(fileItem.sequenceId).to(equal("0"))
                                expect(fileItem.etag).to(equal("0"))
                                expect(fileItem.sha1).to(equal("0bbd79a105c504f99573e3799756debba4c760cd"))
                                expect(fileItem.name).to(equal("testfile.pdf"))

                            case let .failure(error):
                                fail("Expected call to get() to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            describe("create()") {

                it("should make API call to create task when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/tasks")
                            && isMethodPOST()
                            && hasJsonBody([
                                "item": ["type": "file", "id": "7287087200"],
                                "due_at": "2014-04-03T18:09:43Z",
                                "action": "review"
                            ])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("CreateTask.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.tasks.create(fileId: "7287087200", action: .review, dueAt: Date(fromISO8601String: "2014-04-03T11:09:43-07:00")) { result in
                            switch result {
                            case let .success(task):
                                expect(task).to(beAKindOf(Task.self))
                                expect(task.id).to(equal("11111"))
                                expect(task.dueAt?.iso8601).to(equal("2014-04-03T18:09:43Z"))
                                expect(task.action).to(equal(.review))
                                expect(task.message).to(equal("Please review."))

                                guard let item = task.item else {
                                    fail("Task item is not present")
                                    done()
                                    return
                                }

                                guard case let .file(fileItem) = item else {
                                    fail("Task item is not file")
                                    done()
                                    return
                                }

                                expect(fileItem).to(beAKindOf(File.self))
                                expect(fileItem.id).to(equal("22222"))
                                expect(fileItem.sequenceId).to(equal("0"))
                                expect(fileItem.etag).to(equal("0"))
                                expect(fileItem.sha1).to(equal("0bbd79a105c504f99573e3799756debba4c760cd"))
                                expect(fileItem.name).to(equal("box-logo.png"))

                            case let .failure(error):
                                fail("Expected call to create() to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            describe("update()") {

                it("should make API call to update task when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/tasks/11111")
                            && isMethodPUT()
                            && hasJsonBody([
                                "message": "Updated Message",
                                "due_at": "2014-04-03T18:09:43Z",
                                "action": "review",
                                "completion_rule": "any_assignee"
                            ])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("UpdateTask.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.tasks.update(
                            taskId: "11111",
                            action: .review,
                            message: "Updated Message",
                            dueAt: Date(fromISO8601String: "2014-04-03T18:09:43Z"),
                            completionRule: .anyAssignee
                        ) { result in
                            switch result {
                            case let .success(task):
                                expect(task).to(beAKindOf(Task.self))
                                expect(task.id).to(equal("11111"))
                                expect(task.dueAt?.iso8601).to(equal("2014-04-03T18:09:43Z"))
                                expect(task.action).to(equal(.review))
                                expect(task.message).to(equal("Please review."))

                                guard let item = task.item else {
                                    fail("Task item is not present")
                                    done()
                                    return
                                }

                                guard case let .file(fileItem) = item else {
                                    fail("Task item is not file")
                                    done()
                                    return
                                }

                                expect(fileItem).to(beAKindOf(File.self))
                                expect(fileItem.id).to(equal("22222"))
                                expect(fileItem.sequenceId).to(equal("0"))
                                expect(fileItem.etag).to(equal("0"))
                                expect(fileItem.sha1).to(equal("0bbd79a105c504f99573e3799756debba4c760cd"))
                                expect(fileItem.name).to(equal("testfile.pdf"))

                            case let .failure(error):
                                fail("Expected call to update() to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            describe("delete()") {

                it("should make API call to permanently delete task") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/tasks/123456")
                            && isMethodDELETE()
                    ) { _ in
                        OHHTTPStubsResponse(
                            data: Data(), statusCode: 204, headers: [:]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.tasks.delete(taskId: "123456") { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to delete() to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            describe("getAssignment()") {

                it("should make API call to get particular task assignment when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/task_assignments/11111")
                            && isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetTaskAssignment.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.tasks.getAssignment(taskAssignmentId: "11111") { result in
                            switch result {
                            case let .success(taskAssignment):
                                expect(taskAssignment).to(beAKindOf(TaskAssignment.self))
                                expect(taskAssignment.id).to(equal("11111"))
                                expect(taskAssignment.assignedAt?.iso8601).to(equal("2013-05-10T18:43:41Z"))
                                expect(taskAssignment.resolutionState).to(equal(.incomplete))

                                guard
                                    let item = taskAssignment.item,
                                    let assignedTo = taskAssignment.assignedTo,
                                    let assignedBy = taskAssignment.assignedBy
                                else {
                                    fail("Task assigment is not complete")
                                    done()
                                    return
                                }

                                guard case let .file(fileItem) = item else {
                                    fail("Task item is not file")
                                    done()
                                    return
                                }

                                expect(fileItem).to(beAKindOf(File.self))
                                expect(fileItem.id).to(equal("22222"))
                                expect(fileItem.sequenceId).to(equal("0"))
                                expect(fileItem.etag).to(equal("0"))
                                expect(fileItem.sha1).to(equal("7840095ee096ee8297676a138d4e316eabb3ec96"))
                                expect(fileItem.name).to(equal("testfile.pdf"))

                                expect(assignedBy).to(beAKindOf(User.self))
                                expect(assignedBy.id).to(equal("55555"))
                                expect(assignedBy.name).to(equal("Test User"))
                                expect(assignedBy.login).to(equal("testuser@example.com"))

                                expect(assignedTo).to(beAKindOf(User.self))
                                expect(assignedTo.id).to(equal("44444"))
                                expect(assignedTo.name).to(equal("testuser@example.com"))
                                expect(assignedTo.login).to(equal("testuser@example.com"))

                            case let .failure(error):
                                fail("Expected call to getAssignment to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            describe("assign()") {

                it("should make API call to create task assignment when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/task_assignments")
                            && isMethodPOST()
                            && hasJsonBody([
                                "task": [
                                    "id": "1992432",
                                    "type": "task"
                                ],
                                "assign_to": [
                                    "id": "12345"
                                ]
                            ])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("CreateTaskAssignment.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.tasks.assign(taskId: "1992432", userId: "12345") { result in
                            switch result {
                            case let .success(taskAssignment):
                                expect(taskAssignment).to(beAKindOf(TaskAssignment.self))
                                expect(taskAssignment.id).to(equal("11111"))
                                expect(taskAssignment.assignedAt?.iso8601).to(equal("2013-05-10T18:43:41Z"))
                                expect(taskAssignment.resolutionState).to(equal(.incomplete))

                                guard
                                    let item = taskAssignment.item,
                                    let assignedTo = taskAssignment.assignedTo,
                                    let assignedBy = taskAssignment.assignedBy
                                else {
                                    fail("Task assigment is not complete")
                                    done()
                                    return
                                }

                                guard case let .file(fileItem) = item else {
                                    fail("Task item is not file")
                                    done()
                                    return
                                }

                                expect(fileItem).to(beAKindOf(File.self))
                                expect(fileItem.id).to(equal("22222"))
                                expect(fileItem.sequenceId).to(equal("0"))
                                expect(fileItem.etag).to(equal("0"))
                                expect(fileItem.sha1).to(equal("7840095ee096ee8297676a138d4e316eabb3ec96"))
                                expect(fileItem.name).to(equal("testfile.pdf"))

                                expect(assignedBy).to(beAKindOf(User.self))
                                expect(assignedBy.id).to(equal("55555"))
                                expect(assignedBy.name).to(equal("Test User 2"))
                                expect(assignedBy.login).to(equal("testuser2@example.com"))

                                expect(assignedTo).to(beAKindOf(User.self))
                                expect(assignedTo.id).to(equal("44444"))
                                expect(assignedTo.name).to(equal("Test User"))
                                expect(assignedTo.login).to(equal("testuser@example.com"))

                            case let .failure(error):
                                fail("Expected call to assign to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            describe("assignByEmail()") {

                it("should make API call to create task assignment when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/task_assignments")
                            && isMethodPOST()
                            && hasJsonBody([
                                "task": [
                                    "id": "1992432",
                                    "type": "task"
                                ],
                                "assign_to": [
                                    "login": "steve@email.com"
                                ]
                            ])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("CreateTaskAssignment.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.tasks.assignByEmail(taskId: "1992432", email: "steve@email.com") { result in
                            switch result {
                            case let .success(taskAssignment):
                                expect(taskAssignment).to(beAKindOf(TaskAssignment.self))
                                expect(taskAssignment.id).to(equal("11111"))
                                expect(taskAssignment.assignedAt?.iso8601).to(equal("2013-05-10T18:43:41Z"))
                                expect(taskAssignment.resolutionState).to(equal(.incomplete))

                                guard
                                    let item = taskAssignment.item,
                                    let assignedTo = taskAssignment.assignedTo,
                                    let assignedBy = taskAssignment.assignedBy
                                else {
                                    fail("Task assigment is not complete")
                                    done()
                                    return
                                }

                                guard case let .file(fileItem) = item else {
                                    fail("Task item is not file")
                                    done()
                                    return
                                }

                                expect(fileItem).to(beAKindOf(File.self))
                                expect(fileItem.id).to(equal("22222"))
                                expect(fileItem.sequenceId).to(equal("0"))
                                expect(fileItem.etag).to(equal("0"))
                                expect(fileItem.sha1).to(equal("7840095ee096ee8297676a138d4e316eabb3ec96"))
                                expect(fileItem.name).to(equal("testfile.pdf"))

                                expect(assignedBy).to(beAKindOf(User.self))
                                expect(assignedBy.id).to(equal("55555"))
                                expect(assignedBy.name).to(equal("Test User 2"))
                                expect(assignedBy.login).to(equal("testuser2@example.com"))

                                expect(assignedTo).to(beAKindOf(User.self))
                                expect(assignedTo.id).to(equal("44444"))
                                expect(assignedTo.name).to(equal("Test User"))
                                expect(assignedTo.login).to(equal("testuser@example.com"))

                            case let .failure(error):
                                fail("Expected call to assignByEmail to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            describe("updateAssignment()") {

                it("should make API call to update task when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/task_assignments/2698512")
                            && isMethodPUT()
                            && hasJsonBody([
                                "message": "Test Message",
                                "resolution_state": "approved"
                            ])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("UpdateTaskAssignment.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.tasks.updateAssignment(taskAssignmentId: "2698512", message: "Test Message", resolutionState: .approved) { result in
                            switch result {
                            case let .success(taskAssignment):
                                expect(taskAssignment).to(beAKindOf(TaskAssignment.self))
                                expect(taskAssignment.id).to(equal("11111"))
                                expect(taskAssignment.assignedAt?.iso8601).to(equal("2013-05-10T18:43:41Z"))
                                expect(taskAssignment.resolutionState).to(equal(.incomplete))

                                guard
                                    let item = taskAssignment.item,
                                    let assignedTo = taskAssignment.assignedTo,
                                    let assignedBy = taskAssignment.assignedBy
                                else {
                                    fail("Task assigment is not complete")
                                    done()
                                    return
                                }

                                guard case let .file(fileItem) = item else {
                                    fail("Task item is not file")
                                    done()
                                    return
                                }

                                expect(fileItem).to(beAKindOf(File.self))
                                expect(fileItem.id).to(equal("22222"))
                                expect(fileItem.sequenceId).to(equal("0"))
                                expect(fileItem.etag).to(equal("0"))
                                expect(fileItem.sha1).to(equal("7840095ee096ee8297676a138d4e316eabb3ec96"))
                                expect(fileItem.name).to(equal("testfile.pdf"))

                                expect(assignedBy).to(beAKindOf(User.self))
                                expect(assignedBy.id).to(equal("55555"))
                                expect(assignedBy.name).to(equal("Test User"))
                                expect(assignedBy.login).to(equal("testuser@example.com"))

                                expect(assignedTo).to(beAKindOf(User.self))
                                expect(assignedTo.id).to(equal("12345"))
                                expect(assignedTo.name).to(equal("testuser@example.com"))
                                expect(assignedTo.login).to(equal("testuser@example.com"))

                            case let .failure(error):
                                fail("Expected call to updateAssignment to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            describe("deleteTaskAssignment()") {

                it("should make API call to permanently delete task assignment") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/task_assignments/12345")
                            && isMethodDELETE()
                    ) { _ in
                        OHHTTPStubsResponse(
                            data: Data(), statusCode: 204, headers: [:]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.tasks.deleteAssignment(taskAssignmentId: "12345") { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected call to deleteTaskAssignment to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            describe("listAssignments()") {

                it("should make API call to get particular task assignment when call is successful") {
                    stub(
                        condition: isHost("api.box.com")
                            && isPath("/2.0/tasks/12345/assignments")
                            && isMethodGET()
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("GetAssignments.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.sut.tasks.listAssignments(forTaskId: "12345") { result in
                            switch result {
                            case let .success(taskAssignments):
                                guard let firstAssignment = taskAssignments.first else {
                                    fail("Assignment list should not be empty")
                                    done()
                                    return
                                }

                                expect(firstAssignment).to(beAKindOf(TaskAssignment.self))
                                expect(firstAssignment.id).to(equal("11111"))

                                guard
                                    let item = firstAssignment.item,
                                    let assignedTo = firstAssignment.assignedTo
                                else {
                                    fail("Task assigment is not complete")
                                    done()
                                    return
                                }

                                guard case let .file(fileItem) = item else {
                                    fail("Task item is not file")
                                    done()
                                    return
                                }

                                expect(fileItem).to(beAKindOf(File.self))
                                expect(fileItem.id).to(equal("22222"))
                                expect(fileItem.sequenceId).to(equal("0"))
                                expect(fileItem.etag).to(equal("0"))
                                expect(fileItem.sha1).to(equal("0bbd79a105c504f99573e3799756debba4c760cd"))
                                expect(fileItem.name).to(equal("testfile.pdf"))

                                expect(assignedTo).to(beAKindOf(User.self))
                                expect(assignedTo.id).to(equal("44444"))
                                expect(assignedTo.name).to(equal("Test User"))
                                expect(assignedTo.login).to(equal("testuser@example.com"))

                            case let .failure(error):
                                fail("Expected call to listAssignments to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }
        }
    }
}
