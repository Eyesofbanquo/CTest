//
//  AppleMusicModelUnitTests.swift
//  CodeTestTests
//
//  Created by Markim Shaw on 2/18/20.
//  Copyright © 2020 Markim Shaw. All rights reserved.
//

import XCTest

@testable import CodeTest

class AppleMusicModelUnitTests: XCTestCase {
  
  var decoder: JSONDecoder!
  
  override func setUp() {
    super.setUp()
    
    decoder = JSONDecoder()
  }
  
  override func tearDown() {
    decoder = nil
    
    super.tearDown()
  }
  
  func testDecodingAppleMusicDataType() {
    let bundle = Bundle(for: type(of: self))
    
    
    let jsonFilePath = bundle.path(forResource: "album", ofType: "json")
    XCTAssertNotNil(jsonFilePath)
    
    let data = try? Data(contentsOf: URL(fileURLWithPath: jsonFilePath!))
    XCTAssertNotNil(data)
    
    do {
      let decodedJSON = try decoder.decode(AppleMusic.self, from: data!)
      print(decodedJSON)
      XCTAssertNotNil(decodedJSON)
      
      let expectedCount = 2
      let count = decodedJSON.results.count
      XCTAssertEqual(count, expectedCount)
    } catch {
      XCTFail(error.localizedDescription)
    }
    
  }
}
