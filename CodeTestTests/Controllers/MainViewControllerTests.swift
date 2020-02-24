//
//  MainViewControllerTests.swift
//  CodeTestTests
//
//  Created by Markim Shaw on 2/23/20.
//  Copyright © 2020 Markim Shaw. All rights reserved.
//

import XCTest

@testable import CodeTest

class MainViewControllerTests: XCTestCase {
  
  var syncQueue: DispatchQueue!
  var mockStorage: Storage!
  var mockNetwork: Network<AppleMusic>!
  var mockOperation: OperationManager!
  var mockURLSession: URLSession!
  var sut: MainViewController!
  var navigationExp: XCTestExpectation?
  
  override func setUp() {
    super.setUp()
    
    let config = URLSessionConfiguration.default
    config.protocolClasses = [MockURLSessionProtocol.self]
    mockURLSession = URLSession(configuration: config)
//    mockURLSession.finishTasksAndInvalidate()
    
    MockURLSessionProtocol.handler = { request in
      guard let url = request.url else {
        throw NetworkError.invalidURL
      }
      
      let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
      
      if url.absoluteString.contains("json") {
        return (response, self.returnMockData()!)
      } else {
        // Assume the URL is an image
        let image = UIImage(systemName: "play.fill")?.pngData()!
        return (response, image)
      }
    }
    
    syncQueue = DispatchQueue.main
    mockNetwork = Network<AppleMusic>.init(session: mockURLSession, on: syncQueue, cachingEnabled: false)
    
    mockStorage = Storage()
    mockStorage.saveImage(forId: "0", value: UIImage(systemName: "play.fill"))
    
    let operationQueue = OperationQueue()
    operationQueue.maxConcurrentOperationCount = 1
    mockOperation = OperationManager(queue: operationQueue)
    
    sut = MainViewController(storage: mockStorage, network: mockNetwork, operationManager: mockOperation)
  }
  
  override func tearDown() {
    syncQueue = nil
    mockStorage.clearCache()
    mockStorage = nil
    mockNetwork = nil
    mockOperation = nil
    mockURLSession.finishTasksAndInvalidate()
    mockURLSession = nil
    sut = nil
    
    super.tearDown()
  }
  
  func testRetrievingRSSFeed() {
    let exp = expectation(description: "sync")
    
    sut.loadViewIfNeeded()
    
    sut.viewWillAppear(false)
    
    // Performing this async after on a test only DispatchQueue to wait for the main thread in the App Target to complete
    syncQueue.asyncAfter(deadline: .now() + 1.0) {
      exp.fulfill()
    }
    
    waitForExpectations(timeout: 10.0) { _ in
      let expectedCount = 2
      let count = self.sut.storage.count
      XCTAssertEqual(count, expectedCount)
    }
    
  }
  
  func testCreatingNavigationController() {
    let nav = MainViewController.navigationController(storage: mockStorage, network: mockNetwork, operationManager: mockOperation)
    let topViewAsMainVC = nav.topViewController as? MainViewController != nil
    XCTAssertTrue(topViewAsMainVC)
  }
  
  func testLaunchingController() {
    let exp = expectation(description: "sync")
    
    let navigationController = UINavigationController(rootViewController: sut)
    let window = UIWindow()
    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    
    let album = Album(id: "0", title: "A", artist: "B", genres: [], copyright: "C", releaseDate: "D", artwork: "E", appleMusicURL: "F")
    sut.launchDetailViewController(forAlbum: album)
    
    //    let kvoExp = XCTKVOExpectation(keyPath: "topViewController", object: navigationController, expectedValue: "CodeTest.AlbumDetailViewController")
    DispatchQueue.main.async {
      exp.fulfill()
    }
    //    wait(for: [kvoExp], timeout: 10.0)
    waitForExpectations(timeout: 10.0) { _ in
      let launchedAlbumDetailVC = navigationController.topViewController as? AlbumDetailViewController != nil
      XCTAssertTrue(launchedAlbumDetailVC)
    }
  }
  
  /// This test is flawed since it always retrieves an image from the cache
  func testRetrieveImage() {
    let exp = expectation(description: "sync")
    
    let album = Album(id: "0", title: "A", artist: "B", genres: [], copyright: "C", releaseDate: "D", artwork: "E", appleMusicURL: "F")
    
    sut.retrieveImage(forAlbum: album, at: IndexPath(row: 0, section: 0)) { index, image in
      XCTAssertNotNil(image)
      exp.fulfill()
    }
    
    waitForExpectations(timeout: 10.0) { _ in
      XCTAssertTrue(true)
    }
  }
  
}

extension MainViewControllerTests {
  
  func returnMockData() -> Data? {
    let bundle = Bundle(for: type(of: self))
    
    let jsonFilePath = bundle.path(forResource: "album", ofType: "json")
    
    let data = try? Data(contentsOf: URL(fileURLWithPath: jsonFilePath!))
    
    return data
  }
  
}

