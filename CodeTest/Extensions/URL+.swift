//
//  URLRequest+.swift
//  CodeTest
//
//  Created by Markim Shaw on 2/18/20.
//  Copyright © 2020 Markim Shaw. All rights reserved.
//

import Foundation
import UIKit

extension URL: ExpressibleByStringLiteral {
  public typealias StringLiteralType = String
  
  public init(stringLiteral value: String) {
    
    /// In most cases this would actually be a force unwrap since you can create a `URL` from even gibberish. URLs are optional since some of the methods used to create them could be invalid, but since we're using the `URL` init explicitly, this more than likely won't ever be nil.
    self = URL(string: value) ?? URL(fileURLWithPath: "dummy_url")
  }
  
}
