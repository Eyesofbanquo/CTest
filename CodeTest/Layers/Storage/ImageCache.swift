//
//  ImageCache.swift
//  CodeTest
//
//  Created by Markim Shaw on 2/20/20.
//  Copyright © 2020 Markim Shaw. All rights reserved.
//

import Foundation
import UIKit

class ImageCache: NSObject, NSDiscardableContent {
  var image: UIImage!
  
  func beginContentAccess() -> Bool {
    return true
  }
  
  func endContentAccess() {
    
  }
  
  func discardContentIfPossible() {
    
  }
  
  func isContentDiscarded() -> Bool {
    return false
  }
}
