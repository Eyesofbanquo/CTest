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
  
  func testDownloading_REALCALL() {
    let exp = expectation(description: "Downloaded something")
    let exp2 = expectation(description: "Second download")
    
    let downloadOperation = DownloadOperation(id: "0", url: "https://is1-ssl.mzstatic.com/image/thumb/Music123/v4/7d/4a/aa/7d4aaa14-77f8-c9bb-be6d-063d1b5612da/19UM1IM08168.rgb.jpg/200x200bb.png") { id, image in
      print("finished")
      XCTAssertNotNil(image)
      exp.fulfill()
    }
    
    let downloadOperation2 = DownloadOperation(id: "0", url: "https://is1-ssl.mzstatic.com/image/thumb/Music123/v4/7d/4a/aa/7d4aaa14-77f8-c9bb-be6d-063d1b5612da/19UM1IM08168.rgb.jpg/10x10bb.png") { id, image in
      print("finished2")
      XCTAssertNotNil(image)
      exp2.fulfill()
    }
    
    manager.add(id: "0", op: downloadOperation!)
    manager.add(id: "1", op: downloadOperation2!)
    
    wait(for: [exp, exp2], timeout: 10.0)
  }
}
