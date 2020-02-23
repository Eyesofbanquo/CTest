//
//  Album.swift
//  CodeTest
//
//  Created by Markim Shaw on 2/18/20.
//  Copyright © 2020 Markim Shaw. All rights reserved.
//

import Foundation

/// Represents an album item from the `results` object returned from 
struct Album: Decodable {
  
  let id: String
  
  /// The title of the album
  let title: String
  
  /// The album's artist
  let artist: String
  
  /// The album's genre
  let genres: [Genre]
  
  /// Album copyright information
  let copyright: String
  
  /// When the album was/will be released. Provided as a string presented in the following format: `2020-05-01` | `year-month-day`
  let releaseDate: String
  
  /// The artwork associated with the album. Provided as a string with dimensions in the string, ex 200x200. Can replace the 200x200 with custom dimensions.
  let artwork: String
  
  let appleMusicURL: String
  
  enum CodingKeys: String, CodingKey {
    case id, genres, copyright, releaseDate
    case title = "name"
    case artist = "artistName"
    case appleMusicURL = "url"
    case artwork = "artworkUrl100"
  }
  
  var readableDate: String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    guard let date = dateFormatter.date(from: releaseDate) else { return nil }
    
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM d, yyyy"
    
    let stringDate = formatter.string(from: date)
    
    return stringDate
  }
  
}

extension Album {
  
  struct Genre: Decodable {
    
    let id: String
    let name: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
      case id = "genreId"
      case name, url
    }
  }
}
