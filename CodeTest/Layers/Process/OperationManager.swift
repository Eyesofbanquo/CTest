//
//  Process.swift
//  CodeTest
//
//  Created by Markim Shaw on 2/19/20.
//  Copyright © 2020 Markim Shaw. All rights reserved.
//

import Foundation

/// A type that is a wrapper for OperationQueue
class OperationManager {
  
  private var operations: [String: Operation]
  private var queue: OperationQueue
  
  var operationCount: Int {
    return operations.count
  }
  
  init(queue: OperationQueue = .main) {
    self.operations = [:]
    self.queue = queue
  }
  
  func add(id: String, op: Operation) {
    if operations[id]?.isExecuting == true {
      return
    }
    
    operations[id] = op
    queue.addOperation(op)
  }
  
  func get(id: String) -> Operation? {
    return operations[id]
  }
  
  func remove(id: String) {
    if operations[id]?.isExecuting == true {
      return
    }
    
    operations.removeValue(forKey: id)
  }
}
