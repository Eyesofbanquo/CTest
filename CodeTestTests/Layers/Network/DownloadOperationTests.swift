//
//  DownloadOperationTests.swift
//  CodeTestTests
//
//  Created by Markim Shaw on 2/23/20.
//  Copyright © 2020 Markim Shaw. All rights reserved.
//

import XCTest

@testable import CodeTest

class DownloadOperationTests: XCTestCase {
  
  var urlSession: URLSession!
  var operationManager: OperationManager!
  
  override func setUp() {
    super.setUp()
    
    let config = URLSessionConfiguration.default
    config.protocolClasses = [MockURLSessionProtocol.self]
    urlSession = URLSession(configuration: config)
    
    operationManager = OperationManager()
  }
  
  override func tearDown() {
    urlSession = nil
    operationManager = nil
    
    super.tearDown()
  }
  
  func testDownloadOperation_onSuccess() {
    let mockImage = UIImage(systemName: "play")
       let mockData = mockImage?.pngData()!
       
       
       MockURLSessionProtocol.handler = { request in
         guard let url = request.url else {
           throw NetworkError.invalidURL
         }
         
         let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
         
         return (response, mockData!)
       }
    
    // Given: - An image url to download
    let url: URL = "gibberish"
    
    // When: - A download operation is created >
    
    let downloadOperation = DownloadOperation(id: "nil", url: url, session: urlSession) { id, image in
      // Assert: - Image is not nil
      XCTAssertNotNil(image)
    }
    
    // When: - < When a download is started
    operationManager.add(id: "nil", op: downloadOperation!)
  }
  
  func testDownloadOperation_onFailure() {
    
    
    let mockImage = UIImage(systemName: "play")
       let mockData = mockImage?.pngData()!
       
       
       MockURLSessionProtocol.handler = { request in
         guard let url = request.url else {
           throw NetworkError.invalidURL
         }
         
         let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
         
         return (response, mockData!)
       }
    
    // Given: - An image url to download
    let url: URL = "gibberish"
    
    // When: - A download operation is created >
    
    let downloadOperation = DownloadOperation(id: "nil", url: url, session: urlSession) { id, image in
      // Assert: - Image is not nil
      XCTAssertNil(image)
    }
    
    // When: - < When a download is started
    operationManager.add(id: "nil", op: downloadOperation!)
  }
}

extension DownloadOperationTests {
  func returnMockData() -> Data? {
    let bundle = Bundle(for: type(of: self))
    
    let jsonFilePath = bundle.path(forResource: "album", ofType: "json")
    
    let data = try? Data(contentsOf: URL(fileURLWithPath: jsonFilePath!))
    
    return data
  }
}
