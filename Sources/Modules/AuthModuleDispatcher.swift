//
//  AuthModuleDispatcher.swift
//  BoxSDK
//
//  Created by Daniel Cech on 13/06/2019.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

class AuthModuleDispatcher {

    let authQueue = ThreadSafeQueue<AuthActionTuple>(completionQueue: DispatchQueue.main)
    var active = false

    static var current = 1

    func start(action: @escaping AuthActionClosure) {
        let currentId = AuthModuleDispatcher.current
        AuthModuleDispatcher.current += 1

        authQueue.enqueue((id: currentId, action: action)) {
            if !self.active {
                self.active = true
                self.processAction()
            }
        }
    }

    func processAction() {
        authQueue.dequeue { [weak self] action in
            if let unwrappedAction = action {
                unwrappedAction.action {
                    self?.processAction()
                }
            }
            else {
                self?.active = false
            }
        }
    }
}
