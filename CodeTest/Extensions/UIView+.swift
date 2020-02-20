//
//  UIView+.swift
//  CodeTest
//
//  Created by Markim Shaw on 2/19/20.
//  Copyright © 2020 Markim Shaw. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  func sv(_ views: [UIView]) {
    for view in views {
      view.translatesAutoresizingMaskIntoConstraints = false
      self.addSubview(view)
    }
  }
}
