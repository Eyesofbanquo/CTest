//
//  AlbumDetailViewControllerTests.swift
//  CodeTestTests
//
//  Created by Markim Shaw on 2/23/20.
//  Copyright © 2020 Markim Shaw. All rights reserved.
//

import XCTest

@testable import CodeTest

class AlbumDetailViewControllerTests: XCTestCase {
  
  var urlSession: URLSession!
  var artwork: UIImage!
  var mockAlbum: Album!
  var controller: AlbumDetailViewController!
  
  override func setUp() {
    super.setUp()
    
    MockURLSessionProtocol.handler = { request in
      guard let url = request.url else {
        throw NetworkError.invalidURL
      }
      
      let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
      let mockData = UIImage(systemName: "play.fill")?.pngData()!
      
      return (response, mockData)
    }
    
    let config = URLSessionConfiguration.default
    config.protocolClasses = [MockURLSessionProtocol.self]
    urlSession = URLSession(configuration: config)
    
    mockAlbum = Album(id: "0", title: "MMLP2", artist: "Eminem", genres: [.init(id: "0", name: "Rock", url: "http")], copyright: "none", releaseDate: "2020-05-06", artwork: "https://is1-ssl.mzstatic.com/image/thumb/Music123/v4/7d/4a/aa/7d4aaa14-77f8-c9bb-be6d-063d1b5612da/19UM1IM08168.rgb.jpg/200x200bb.png", appleMusicURL: "none")
    artwork = UIImage(systemName: "play")
    
    /// Inject an OperationQueue of `.maxConcurrentOperationCount = 1` to force a synchronous request
    let mockQueue = OperationQueue()
    mockQueue.maxConcurrentOperationCount = 1
    controller = AlbumDetailViewController(album: mockAlbum, artwork: artwork, queueManager: .init(queue: mockQueue), urlSession: urlSession)
  }
  
  override func tearDown() {
    urlSession.invalidateAndCancel()
    urlSession = nil
    artwork = nil
    mockAlbum = nil
    controller = nil
    
    super.tearDown()
  }
  
  func testViewAsAlbumDetailViewControllerDisplayable() {
    // Given: - The view loads
    controller.loadViewIfNeeded()
    
    // Then: - the default view is of type AlbumDetailViewControllerDisplayable
    let isDisplayableViewType = controller.view as? AlbumDetailViewControllerDisplayable != nil
    XCTAssertTrue(isDisplayableViewType)
  }
  
  func testInitialImageDownloads() {
    // Given: - View loads
    controller.loadViewIfNeeded()
    
    // When: - A download begins automatically
    
    // Then: - The OperationManager has a running task
    let taskIsRunning = controller.operationManager.hasRunningOperations
    XCTAssertTrue(taskIsRunning)
  }
  
}
