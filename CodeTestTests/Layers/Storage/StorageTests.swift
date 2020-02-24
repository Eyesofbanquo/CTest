//
//  StorageTests.swift
//  CodeTestTests
//
//  Created by Markim Shaw on 2/19/20.
//  Copyright © 2020 Markim Shaw. All rights reserved.
//

import XCTest

@testable import CodeTest

class StorageTests: XCTestCase {
  
  var sut: Storage!
  
  override func setUp() {
    super.setUp()
    
    sut = Storage()
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
  
  func testAddingAlbum() {
    // Given: - An album to add
    let album = albums[0]
    
    // When: - An album is added to storage
    sut.add(album: album)
    
    // Then: - Storage should have a count of 1
    let expectedCount = 1
    let count = sut.count
    XCTAssertEqual(count, expectedCount)
  }
  
  func testAddingAlbums() {
    // Given: - An arbitrary number of albums to add
    let albums = self.albums
    
    // When: - Albums are added to storage
    sut.add(albums: albums)
    
    // Then: - Storage should have same count as albums added
    let expectedCount = albums.count
    let count = sut.count
    XCTAssertEqual(count, expectedCount)
  }
  
  func testRetrievingAlbum_ByIndex_NoItems() {
    // Given: - Storage doesn't contain any albums
    let expectedCount = 0
    let count = sut.count
    XCTAssertEqual(count, expectedCount)
    
    // When: - User tries to retrieve an album by index
    let arbitraryIndex: Int = 0
    let album = sut.get(index: arbitraryIndex)
    
    // Then: - Storage should return nil
    XCTAssertNil(album)
  }
  
  func testRetrievingAlbum_ById_NoItems() {
    // Given: - Storage doesn't contain any albums
    let expectedCount = 0
    let count = sut.count
    XCTAssertEqual(count, expectedCount)
    
    // When: - User tries to retrieve an album by index
    let arbitraryId: String = "0"
    let album = sut.get(id: arbitraryId)
    
    // Then: - Storage should return nil
    XCTAssertNil(album)
  }
  
  func testRetrievingAlbum_ById() {
    // Given: - Storage contains albums
    sut.add(albums: albums)
    let expectedCount = 2
    let count = sut.count
    XCTAssertEqual(count, expectedCount)
    
    // When: - User tries to retrieve an album by index
    let arbitraryId: String = "0"
    let album = sut.get(id: arbitraryId)
    
    // Then: - Storage should return nil
    XCTAssertNotNil(album)
  }
  
  func testImageCache() {
    // Given: - An image exists and album id exists
    let album = albums[0]
    let image = UIImage(systemName: "play")
    
    // When: - Image is added to cache
    sut.saveImage(forId: album.id, value: image)
    
    // Then: - Image can be retrieved from cache
    let cachedImage = sut.retrieveImage(forId: album.id)
    XCTAssertEqual(cachedImage, image)
  }
}

extension StorageTests {
  
  private var albums: [Album] {
    return [
      Album(id: "0", title: "24k Magic", artist: "Bruno Mars", genres: [Album.Genre(id: "0", name: "Pop", url: "www.haha.com")], copyright: "Nope", releaseDate: "2020-05-01", artwork: "nope", appleMusicURL: "itunes.com"),
      Album(id: "1", title: "25k Magic", artist: "Bruno Mared", genres: [Album.Genre(id: "0", name: "Pop", url: "www.haha.com")], copyright: "Nope", releaseDate: "2020-05-01", artwork: "nope", appleMusicURL: "itunes.com")
    ]
  }
}
