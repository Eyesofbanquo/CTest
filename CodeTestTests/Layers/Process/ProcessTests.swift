//
//  ProcessTests.swift
//  CodeTestTests
//
//  Created by Markim Shaw on 2/19/20.
//  Copyright © 2020 Markim Shaw. All rights reserved.
//

/*
 This will only be one unit test for now since the manager class makes real network calls.
 */

import XCTest

@testable import CodeTest

class ProcessTests: XCTestCase {
  
  var manager: OperationManager!
  
  override func setUp() {
    super.setUp()
    
    manager = OperationManager()
  }
  
  override func tearDown() {
    manager = nil
    
    super.tearDown()
  }
  
  func testAddingOperations() {
    let testSession = URLSession(configuration: .ephemeral)
    let downloadOperation = DownloadOperation(id: "0", url: "https://is1-ssl.mzstatic.com/image/thumb/Music123/v4/7d/4a/aa/7d4aaa14-77f8-c9bb-be6d-063d1b5612da/19UM1IM08168.rgb.jpg/200x200bb.png", session: testSession) { id, image in
      XCTAssertNotNil(image)
    }
    
    let downloadOperation2 = DownloadOperation(id: "0", url: "https://is1-ssl.mzstatic.com/image/thumb/Music123/v4/7d/4a/aa/7d4aaa14-77f8-c9bb-be6d-063d1b5612da/19UM1IM08168.rgb.jpg/10x10bb.png", session: testSession) { id, image in
      XCTAssertNotNil(image)
    }
    
    self.manager.add(id: "0", op: downloadOperation!)
    self.manager.add(id: "1", op: downloadOperation2!)
    
    let expectedCount = 2
    let count = self.manager.operationCount
    
    XCTAssertEqual(expectedCount, count)
  }
  
  func testAddingOperations_SameOperation() {
    let testSession = URLSession(configuration: .ephemeral)
    let downloadOperation = DownloadOperation(id: "0", url: "https://is1-ssl.mzstatic.com/image/thumb/Music123/v4/7d/4a/aa/7d4aaa14-77f8-c9bb-be6d-063d1b5612da/19UM1IM08168.rgb.jpg/200x200bb.png", session: testSession) { id, image in
      XCTAssertNotNil(image)
    }
    
    let downloadOperation2 = DownloadOperation(id: "0", url: "https://is1-ssl.mzstatic.com/image/thumb/Music123/v4/7d/4a/aa/7d4aaa14-77f8-c9bb-be6d-063d1b5612da/19UM1IM08168.rgb.jpg/10x10bb.png", session: testSession) { id, image in
      XCTAssertNotNil(image)
    }
    
    self.manager.add(id: "0", op: downloadOperation!)
    self.manager.add(id: "0", op: downloadOperation2!)
    
    let expectedCount = 1
    let count = self.manager.operationCount
    
    XCTAssertEqual(expectedCount, count)
  }
  
  func testGettingOperation() {
    let testSession = URLSession(configuration: .ephemeral)
    let downloadOperation = DownloadOperation(id: "0", url: "https://is1-ssl.mzstatic.com/image/thumb/Music123/v4/7d/4a/aa/7d4aaa14-77f8-c9bb-be6d-063d1b5612da/19UM1IM08168.rgb.jpg/200x200bb.png", session: testSession) { id, image in
      XCTAssertNotNil(image)
    }
    
    self.manager.add(id: "0", op: downloadOperation!)
    
    let retrievedOperation = self.manager.get(id: "0")
    
    XCTAssertEqual(retrievedOperation, downloadOperation)
    
  }
  
  func testRemovingOperation() {
    let testSession = URLSession(configuration: .ephemeral)
    let downloadOperation = DownloadOperation(id: "0", url: "https://is1-ssl.mzstatic.com/image/thumb/Music123/v4/7d/4a/aa/7d4aaa14-77f8-c9bb-be6d-063d1b5612da/19UM1IM08168.rgb.jpg/200x200bb.png", session: testSession) { id, image in
      XCTAssertNotNil(image)
    }
    
    self.manager.add(id: "0", op: downloadOperation!)
    
    self.manager.remove(id: "0")
    
    let expectedCount = 0
    let count = self.manager.operationCount
    XCTAssertEqual(expectedCount, count)
    
  }
}
