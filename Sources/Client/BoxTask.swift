//
//  BoxTask.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 3/21/20.
//  Copyright © 2020 box. All rights reserved.
//

import Foundation

/// Represents Box Task request.
public class BoxTask {

    var taskMethod: ((URLSessionTask) -> Void)?
    var task: URLSessionTask?
    var cancelBool: Bool
    var pauseBool: Bool

    init() {
        cancelBool = false
        pauseBool = false
    }
}

// MARK: - Request Endpoint Construction

extension BoxTask {
    public func getTask() -> ((URLSessionTask) -> Void) {
        taskMethod = { sessionTask in
            if self.cancelBool {
                sessionTask.cancel()
            }
//            else if self.pauseBool {
//                sessionTask.suspend()
//            }
            else {
                self.task = sessionTask
            }
        }
        return taskMethod!
    }

//
//    public func resume() {
//        if let unwrappedTask = task {
//            unwrappedTask.resume()
//        }
//        else {
//            resumeBool = true
//        }
//    }

//    public func pause() {
//        if let unwrappedTask = task {
//            unwrappedTask.suspend()
//        }
//        else {
//            pauseBool = true
//        }
//    }

    public func cancel() {
        if let unwrappedTask = task {
            unwrappedTask.cancel()
        }
        else {
            cancelBool = true
        }
    }
}
