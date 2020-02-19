//
//  Storage.swift
//  CodeTest
//
//  Created by Markim Shaw on 2/18/20.
//  Copyright © 2020 Markim Shaw. All rights reserved.
//

import Foundation
import UIKit

/// This class represents the database/storage layer. Since this project won't be using Realm/Core Data then the storage is all in memory. This will hold the `Album` struct values and also an `NSCache` for images.
class Storage {
  
  // MARK: - Properties -
  
  private var cache: NSCache<NSString, UIImage>
  
  private var store: [Album]
  
  var count: Int {
    return store.count
  }
  
  init() {
    cache = NSCache<NSString, UIImage>()
    store = []
  }
  
  deinit {
    cache.removeAllObjects()
    store.removeAll()
  }
  
  // MARK: - In Memory Storage -
  
  /// This function will add the given album to the store.
  func add(album: Album) {
    self.store.append(album)
  }
  
  /// This function will add a list of albums to the store
  func add(albums: [Album]) {
    self.store.append(contentsOf: albums)
  }
  
  /// This function will find the provided album and remove it from the data store. This is a mutating function.
  func remove(album: Album) {
    let index = self.store.firstIndex(where: { $0.id == album.id })
    if let foundIndex = index {
      self.store.remove(at: foundIndex)
    }
  }
  
  /// This function allows you to retrieve an album by `id`. Returns nil if the album can't be found or if an invalid index was passed through
  func get(id: String?) -> Album? {
    guard let id = id else { return nil }
    
    let index = self.store.firstIndex(where: { $0.id == id })
    if let foundIndex = index {
      return self.store[foundIndex]
    }
    
    return nil
  }
  
  /// This function allows you to retrieve an album by `index`. Returns nil if the album can't be found or if an invalid index was passed through
  func get(index: Int) -> Album? {
    guard 0..<store.count ~= index else { return nil }
    
    
    return store[index]
  }
  
  // MARK: - Cache Storage -
  
  func saveImage(forId id: String, value: UIImage?) {
     guard let image = value else { return }
     
     cache.setObject(image, forKey: id as NSString)
   }
   
   func retrieveImage(forId id: String) -> UIImage? {
     return cache.object(forKey: id as NSString)
   }
}
