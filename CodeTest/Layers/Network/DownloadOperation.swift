//
//  DownloadOperation.swift
//  CodeTest
//
//  Created by Markim Shaw on 2/19/20.
//  Copyright © 2020 Markim Shaw. All rights reserved.
//

import Foundation
import UIKit

class DownloadOperation: Operation {
  
  // MARK: - Properties -
  
  private var _isFinished: Bool = false
  private var _isReady: Bool = false
  private var _isExecuting: Bool = false
  private var _isCancelled: Bool = false
  
  private var id: String
  private var url: URL
  private var session: URLSession
  private var completion: (String?, UIImage?) -> Void
  private var dataTask: URLSessionDataTask?
  
  override var isCancelled: Bool {
    get {
      return _isCancelled
    }
    
    set {
      willChangeValue(forKey: "isCancelled")
      _isCancelled = newValue
      didChangeValue(forKey: "isCancelled")
    }
  }
  
  override var isReady: Bool {
    get {
      return _isReady
    }
    
    set {
      willChangeValue(forKey: "isReady")
      _isReady = newValue
      didChangeValue(forKey: "isReady")
    }
  }
  
  override var isExecuting: Bool {
    get {
      return _isExecuting
    }
    
    set {
      willChangeValue(forKey: "isExecuting")
      _isExecuting = newValue
      didChangeValue(forKey: "isExecuting")
    }
  }
  
  override var isAsynchronous: Bool {
    return true
  }
  
  override var isFinished: Bool {
    get {
      return _isFinished
    }
    
    set {
      willChangeValue(forKey: "isFinished")
      _isFinished = newValue
      didChangeValue(forKey: "isFinished")
    }
  }
  
  // MARK: - Init -
  
  init?(id: String, url: URL?, session: URLSession = .shared, completion: @escaping ((String?, UIImage?) -> Void)) {
    guard let url = url else {
      return nil
    }
    
    self.id = id
    self.url = url
    self.session = session
    self.completion = completion
    
    super.init()
    
    self.isReady = true
  }
  
  override func start() {
    guard !isCancelled else { return }
    
    isFinished = false
    isExecuting = true
    
    let request = URLRequest(url: url)
    dataTask = session.dataTask(with: request) { [weak self] data, response, error in
      guard let data = data, error == nil, self?.isCancelled == false else {
        self?.isFinished = true
        self?.isExecuting = false
        return
      }
      
      // Completion handler should accept an id and be of type (String) -> Void
      // Pass in the id in the completion so that on the main thread in the calling class
      // It can use this id to do 2 things
      // 1. Immediately save image to cache
      // 2. Check to see if the id matches a visible cell's id. If so then update cell, if not then do nothing
      
      let image = UIImage(data: data)
      
      DispatchQueue.main.async {
        self?.completion(self?.id, image)
        self?.isFinished = true
        self?.isExecuting = false
      }
      
    }
    
    dataTask?.resume()
  }
  
  override func cancel() {
    dataTask?.cancel()
    isCancelled = true
  }
}
