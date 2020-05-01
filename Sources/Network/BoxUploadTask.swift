//
//  BoxUploadTask.swift
//  BoxSDK-iOS
//
//  Created by Sujay Garlanka on 4/24/20.
//  Copyright © 2020 box. All rights reserved.
//

import Foundation

/// A Box network task returned for a upload
public class BoxUploadTask: BoxNetworkTask {
    var nestedTasks: [BoxNetworkTask] = []

    /// Closure that is called when API calls are nested within each other
    func receiveTask(_ networkTask: BoxNetworkTask) {
        if cancelled {
            cancelNestedTasks()
        }
        else {
            nestedTasks.append(networkTask)
        }
    }

    /// Method to cancel an Box Upload Task
    public override func cancel() {
        task?.cancel()
        cancelNestedTasks()
        cancelled = true
    }

    /// Method to cancel all tasks created for a Box Upload Task
    private func cancelNestedTasks() {
        for networkTask in nestedTasks {
            networkTask.cancel()
        }
    }
}
