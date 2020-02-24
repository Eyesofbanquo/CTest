//
//  Network.swift
//  CodeTest
//
//  Created by Markim Shaw on 2/18/20.
//  Copyright © 2020 Markim Shaw. All rights reserved.
//

import Foundation

/// A class responsible for performing network calls against the Apple Music API
final class Network<ModelType: Decodable> {
  
  // MARK: - Properties -
  
  private let networkTimeout: TimeInterval
  private(set) var session: URLSession
  private(set) var queue: DispatchQueue
  private(set) var cachingEnabled: Bool
  
  init(session: URLSession = URLSession.shared, on queue: DispatchQueue = .main, timeout: TimeInterval = 60.0, cachingEnabled: Bool = false) {
    self.networkTimeout = timeout
    self.session = session
    self.queue = queue
    self.cachingEnabled = cachingEnabled
  }
  
  /// Performs a standard get request to retrieve content at the specified url. This supports caching
  /// - Parameters:
  ///   - url: The url containing the endpoint to hit for the `GET` request.
  ///   - completion: Returns the generic model type, decoded, as assigned through declaration of the Network object
  func get(url: URL?, _ completion: ((Result<ModelType, NetworkError>) -> Void)? = nil) {
    
    guard let url = url else {
      completion?(.failure(.invalidURL))
      return
    }
    
    var request: URLRequest
    
    if self.cachingEnabled {
      request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: networkTimeout)
    } else {
      request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: networkTimeout)
    }
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-type")
    
    let cache = session.configuration.urlCache
    if let cachedResponse = cache?.cachedResponse(for: request), cachingEnabled == true {
      // If the cached response exists then just break down that JSON and immediately return it
      queue.async {
        do {
          let decoder = JSONDecoder()
          let results = try decoder.decode(ModelType.self, from: cachedResponse.data)
          completion?(.success(results))
        } catch {
          completion?(.failure(.decodingError(message: error.localizedDescription)))
        }
      }
      
      return
    }
    
    let dataTask = session.dataTask(with: request) { [weak self] data, response, error in
      self?.queue.async {
        
        guard error == nil else {
          completion?(.failure(.invalidData))
          return
        }
        
        // Check status code is between 200 and 400. This uses a pattern matching operator to bypass a longer && statement
        guard let httpResponse = response as? HTTPURLResponse, 200..<400 ~= httpResponse.statusCode else {
          completion?(.failure(.invalidResponse))
          return
        }
        
        guard let data = data else {
          completion?(.failure(.invalidData))
          return
        }
        
        do {
          let decoder = JSONDecoder()
          let results = try decoder.decode(ModelType.self, from: data)
          completion?(.success(results))
        } catch {
          completion?(.failure(.decodingError(message: error.localizedDescription)))
        }
      }
      
    }
    
    dataTask.resume()
  }
}
