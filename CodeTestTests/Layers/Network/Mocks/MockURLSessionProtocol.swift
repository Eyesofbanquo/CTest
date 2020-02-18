//
//  MockURLSessionProtocol.swift
//  CodeTestTests
//
//  Created by Markim Shaw on 2/18/20.
//  Copyright © 2020 Markim Shaw. All rights reserved.
//

import Foundation

/**
 
 The idea for this type of mock was presented in WWDC 2018 and is more than likely how frameworks like `Moya` handle mocking data for network calls. This class of type `URLProtocol`. `URLProtocol`s are used on `URLSession`s to tell the session how to handle a given `URLRequest`. By mocking this part of the network call you can choose what data to send back to the calling function. The alternative of using this for unit tests would be injecting data into either a view model or the controller directly. That "works" but doesn't prevent the network call from happening at all. This mock will stop all network calls and _only_ return data. Basically, this mock allows you to test your network layer directly in a production setting instead of testing viewmodel data injects.
 
 */
final class MockURLSessionProtocol: URLProtocol {
  
  static var handler: ((URLRequest) throws -> (response: HTTPURLResponse, data: Data?))?
  
  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }
  
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    /// Apple states that it's up to the URLProtocol to decide what is considered a canonical request so for this mock I'll just be returning whatever request was passed through.
    return request
  }
  
  override func startLoading() {
    guard let handler = MockURLSessionProtocol.handler else {
      fatalError("No handler was provided. Provide one in a test case")
    }
    
    do {
      let response = try handler(request).response
      let data = try handler(request).data
      
      /// The client is an object on URLProtocol that can communicate with the session that called on this protocol
      client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      
      if let data = data {
        client?.urlProtocol(self, didLoad: data)
      }
      
      client?.urlProtocolDidFinishLoading(self)
    } catch {
      client?.urlProtocol(self, didFailWithError: error)
    }
  }
  
  override func stopLoading() {
    
  }
}
