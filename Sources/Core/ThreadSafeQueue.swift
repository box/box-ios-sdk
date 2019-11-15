//
//  ThreadSafeQueue.swift
//  BoxSDK
//
//  Created by Daniel Cech on 13/06/2019.
//  Copyright © 2019 Box. All rights reserved.
//

import Foundation

class ThreadSafeQueue<T> {
    private var list = [T]()
    private let utilityQueue = DispatchQueue(label: "com.box.swiftsdk.threadsafequeue", qos: .utility)
    private var completionQueue: DispatchQueue

    init(completionQueue: DispatchQueue) {
        self.completionQueue = completionQueue
    }

    func enqueue(_ element: T, completion: (() -> Void)? = nil) {
        utilityQueue.async { [weak self] in
            self?.list.append(element)
            completion?()
        }
    }

    func dequeue(completion: @escaping (T?) -> Void) {
        utilityQueue.async { [weak self] in
            guard let self = self else {
                return
            }

            self.completionQueue.async {
                if !self.list.isEmpty {
                    completion(self.list.removeFirst())
                }
                else {
                    completion(nil)
                }
            }
        }
    }

    func peek(completion: @escaping (T?) -> Void) {
        utilityQueue.async { [weak self] in
            guard let self = self else {
                return
            }

            self.completionQueue.async {
                if !self.list.isEmpty {
                    completion(self.list[0])
                }
                else {
                    completion(nil)
                }
            }
        }
    }

    func isEmpty(completion: @escaping (Bool) -> Void) {
        utilityQueue.async { [weak self] in
            guard let self = self else {
                return
            }

            let empty = self.list.isEmpty
            self.completionQueue.async {
                completion(empty)
            }
        }
    }
}
