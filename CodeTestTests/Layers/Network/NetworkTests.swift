//
//  NetworkTests.swift
//  CodeTestTests
//
//  Created by Markim Shaw on 2/18/20.
//  Copyright © 2020 Markim Shaw. All rights reserved.
//

import XCTest

@testable import CodeTest

class NetworkTests: XCTestCase {
  
  var testSession: URLSession!
  var queue: DispatchQueue!
  var network: Network<AppleMusic>!
  
  override func setUp() {
    super.setUp()
    
    queue = DispatchQueue(label: "Test queue")
    
    let config = URLSessionConfiguration.default
    config.protocolClasses = [MockURLSessionProtocol.self]
    testSession = URLSession(configuration: config)
    network = Network<AppleMusic>(session: testSession, on: queue)
  }
  
  override func tearDown() {
    testSession.finishTasksAndInvalidate()
    testSession = nil
    network = nil
    queue = nil
    super.tearDown()
  }
  
  func testLoadsMockData_onSuccess() {
    // Given: - Mock data
    let exp = expectation(description: "Wait for network")
    
    let mockData = returnMockData()
    
    // When: - MockURLSessionProtocol is setup
    MockURLSessionProtocol.handler = { request in
      guard let url = request.url else {
        throw NetworkError.invalidURL
      }
      
      let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
      
      return (response, mockData)
    }
    
    network.get(url: "https://www.google.com", cachingEnabled: false) { results in
      switch results {
      case .success(let appleMusicData):
        let results = appleMusicData.results
        
        let expectedCount = 2
        let count = results.count
        XCTAssertEqual(count, expectedCount)
      case .failure(let error):
        XCTFail(error.localizedDescription)
      }
      exp.fulfill()
      
    }
    wait(for: [exp], timeout: 1.0)

  }
  
  func testLoadsMockData_onStatusCodeError() {
    // Given: - Mock data
    
    let exp = expectation(description: "Wait for data to load")
    
    let mockData = returnMockData()
    
    // When: - MockURLSessionProtocol is setup
    MockURLSessionProtocol.handler = { request in
      guard let url = request.url else {
        throw NetworkError.invalidURL
      }
      
      let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
      
      return (response, mockData)
    }
    
    network.get(url: "https://www.google.com", cachingEnabled: false) { results in
      switch results {
      case .success:
        XCTFail("This shouldn't load at all")
      case .failure(let error):
        switch error {
        case .invalidResponse:
          XCTAssertTrue(true)
        default: break
        }
      }
      exp.fulfill()
    }

    wait(for: [exp], timeout: 1.0)
  }
  
}

extension NetworkTests {
  
  func returnMockData() -> Data? {
    let bundle = Bundle(for: type(of: self))
    
    let jsonFilePath = bundle.path(forResource: "album", ofType: "json")
    
    let data = try? Data(contentsOf: URL(fileURLWithPath: jsonFilePath!))
    
    return data
  }
}
