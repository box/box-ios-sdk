//
//  TaskSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Matthew Willer on 6/18/19.
//  Copyright © 2019 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class TaskSpecs: QuickSpec {

    override func spec() {
        describe("Task") {
            describe("init()") {
                it("should correctly deserialize from full JSON representation") {
                    guard let filepath = Bundle(for: type(of: self)).path(forResource: "FullTask", ofType: "json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let task = try Task(json: jsonDict)

                        expect(task.type).to(equal("task"))
                        expect(task.id).to(equal("11111"))

                        guard case let .file(file)? = task.item else {
                            fail("Could not unwrap expected item")
                            return
                        }
                        expect(file.type).to(equal("file"))
                        expect(file.id).to(equal("22222"))
                        expect(file.name).to(equal("test.pdf"))
                        expect(file.etag).to(equal("0"))
                        expect(file.sequenceId).to(equal("0"))
                        expect(file.sha1).to(equal("617982d8e2e5cacb5dd0efb690e6000574b7ea24"))
                        expect(file.fileVersion?.type).to(equal("file_version"))
                        expect(file.fileVersion?.id).to(equal("33333"))
                        expect(file.fileVersion?.sha1).to(equal("617982d8e2e5cacb5dd0efb690e6000574b7ea24"))

                        expect(task.dueAt?.iso8601).to(equal("2019-06-29T06:59:59Z"))
                        expect(task.action?.description).to(equal("review"))
                        expect(task.message).to(equal("Please review"))
                        expect(task.taskAssignmentCollection?.totalCount).to(equal(1))
                        expect(task.taskAssignmentCollection?.entries.count).to(equal(1))
                        expect(task.taskAssignmentCollection?.entries[0].type).to(equal("task_assignment"))
                        expect(task.taskAssignmentCollection?.entries[0].id).to(equal("12345"))
                        expect(task.taskAssignmentCollection?.entries[0].message).to(equal(""))
                        expect(task.taskAssignmentCollection?.entries[0].status).to(equal(.incomplete))
                        expect(task.taskAssignmentCollection?.entries[0].resolutionState).to(equal(.incomplete))

                        guard case let .file(assignmentFile)? = task.taskAssignmentCollection?.entries[0].item else {
                            fail("Could not unwrap expected item")
                            return
                        }
                        expect(assignmentFile.type).to(equal("file"))
                        expect(assignmentFile.id).to(equal("22222"))
                        expect(assignmentFile.name).to(equal("test.pdf"))
                        expect(assignmentFile.sequenceId).to(equal("0"))
                        expect(assignmentFile.etag).to(equal("0"))
                        expect(assignmentFile.sha1).to(equal("617982d8e2e5cacb5dd0efb690e6000574b7ea24"))
                        expect(assignmentFile.fileVersion?.type).to(equal("file_version"))
                        expect(assignmentFile.fileVersion?.id).to(equal("33333"))
                        expect(assignmentFile.fileVersion?.sha1).to(equal("617982d8e2e5cacb5dd0efb690e6000574b7ea24"))

                        expect(task.taskAssignmentCollection?.entries[0].assignedTo?.type).to(equal("user"))
                        expect(task.taskAssignmentCollection?.entries[0].assignedTo?.id).to(equal("44444"))
                        expect(task.taskAssignmentCollection?.entries[0].assignedTo?.name).to(equal("Example User"))
                        expect(task.taskAssignmentCollection?.entries[0].assignedTo?.login).to(equal("user@example.com"))
                        expect(task.taskAssignmentCollection?.entries[0].assignedAt?.iso8601).to(equal("2019-06-18T18:48:19Z"))
                        expect(task.taskAssignmentCollection?.entries.count).to(equal(1))
                        expect(task.taskAssignmentCollection?.entries[0].type).to(equal("task_assignment"))
                        expect(task.taskAssignmentCollection?.entries[0].id).to(equal("12345"))
                        expect(task.taskAssignmentCollection?.entries[0].message).to(equal(""))
                        expect(task.taskAssignmentCollection?.entries[0].status).to(equal(.incomplete))
                        expect(task.taskAssignmentCollection?.entries[0].resolutionState).to(equal(.incomplete))

                        expect(task.isCompleted).to(beFalse())
                        expect(task.createdBy?.type).to(equal("user"))
                        expect(task.createdBy?.id).to(equal("55555"))
                        expect(task.createdBy?.name).to(equal("Example Manager"))
                        expect(task.createdBy?.login).to(equal("manager@example.com"))
                        expect(task.createdAt?.iso8601).to(equal("2019-06-18T18:48:18Z"))
                        expect(task.completionRule?.description).to(equal("all_assignees"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
