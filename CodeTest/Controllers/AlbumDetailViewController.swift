//
//  AlbumDetailViewController.swift
//  CodeTest
//
//  Created by Markim Shaw on 2/20/20.
//  Copyright © 2020 Markim Shaw. All rights reserved.
//

import Foundation
import UIKit

protocol AlbumDetailViewControllerDisplayable {
  func updateBackgroundImage(image: UIImage?)
}

class AlbumDetailViewController: UIViewController {
  
  // MARK: - Properties -
  
  private var album: Album
  
  private var artwork: UIImage?
  
  lazy var operationManager: OperationManager = OperationManager()
  
  var displaybleView: AlbumDetailViewControllerDisplayable? {
    return view as? AlbumDetailViewControllerDisplayable
  }
  
  init(album: Album, artwork: UIImage?) {
    self.album = album
    self.artwork = artwork
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("No storyboards")
  }
  
  // MARK: - Lifecycle -
  
  override func loadView() {
    let detailView = AlbumDetailView(album: album, artwork: artwork)
    
    let albumReleaseDate = formatDate(fromString: album.releaseDate)
    detailView.setReleaseDateLabel(releaseDate: albumReleaseDate)
    
    view = detailView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Upcoming Album"
    
    let largeArtwork = album.artwork.replacingOccurrences(of: "200x200", with: "1000x1000")
    if let downloadOp = (DownloadOperation(id: album.id, url: URL(string:largeArtwork)) { [weak self] index, image in
      self?.displaybleView?.updateBackgroundImage(image: image)
    }) {
      operationManager.add(id: album.id, op: downloadOp)
    }
  }
}

extension AlbumDetailViewController: AlbumDetailViewDelegate {
  func formatDate(fromString releaseDate: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    guard let date = dateFormatter.date(from: releaseDate) else { return nil }
    
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM d, yyyy"
//    formatter.dateStyle = .medium
    
    let stringDate = formatter.string(from: date)
    
    return stringDate
  }
  
  
}
