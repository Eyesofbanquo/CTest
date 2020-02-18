//
//  AppleMusic.swift
//  CodeTest
//
//  Created by Markim Shaw on 2/18/20.
//  Copyright © 2020 Markim Shaw. All rights reserved.
//

import Foundation

struct AppleMusic: Decodable {
  let results: [Album]
  
  /// The default keys used to parse the top level feed object.
  enum FeedKeys: String, CodingKey {
    case feed
    case results
  }
  
  /// The keys used to parse the results array object that lives in the feed object
  enum ResultsKeys: String, CodingKey {
    case results
  }
}

extension AppleMusic {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: FeedKeys.self)
    
    let resultsContainer = try container.nestedContainer(keyedBy: FeedKeys.self, forKey: .feed)
    self.results = try resultsContainer.decode([Album].self, forKey: .results)
    
  }
}
