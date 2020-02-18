//
//  NetworkError.swift
//  CodeTest
//
//  Created by Markim Shaw on 2/18/20.
//  Copyright © 2020 Markim Shaw. All rights reserved.
//

import Foundation

/// A generic error keyset for the `Network` object.
enum NetworkError: Error {
  case invalidResponse
  case invalidURL
  case invalidImageURL
  case invalidData
}
