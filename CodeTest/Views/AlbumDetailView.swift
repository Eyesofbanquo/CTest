//
//  AlbumDetailView.swift
//  CodeTest
//
//  Created by Markim Shaw on 2/20/20.
//  Copyright © 2020 Markim Shaw. All rights reserved.
//

import Foundation
import UIKit

protocol AlbumDetailViewDelegate: AnyObject {
  func formatDate(fromString releaseDate: String) -> String? 
}

class AlbumDetailView: UIView {
  
  // MARK: - Properties -
  
  weak var delegate: AlbumDetailViewDelegate?
  
  var album: Album
  
  // MARK: - Views -
  
  var albumArtworkImageView: UIImageView
  
  var albumArtistLabel: UILabel
  
  var albumTitleLabel: UILabel
  
  var albumGenreLabel: UILabel
  
  var albumCopyrightLabel: UILabel
  
  var albumReleaseDateLabel: UILabel
  
  var openURLButton: UIButton
  
  init(album: Album, artwork: UIImage?) {
    self.album = album
    self.albumArtworkImageView = UIImageView()
    self.albumArtistLabel = UILabel()
    self.albumTitleLabel = UILabel()
    self.albumGenreLabel = UILabel()
    self.albumCopyrightLabel = UILabel()
    self.albumReleaseDateLabel = UILabel()
    self.openURLButton = UIButton(type: .system)
    
    super.init(frame: .zero)
    
    backgroundColor = .systemBackground
    
    self.albumArtworkImageView.image = artwork
    self.albumArtworkImageView.layoutIfNeeded()
    self.albumArtworkImageView.translatesAutoresizingMaskIntoConstraints = false
    self.albumArtworkImageView.contentMode = .scaleAspectFit
    self.albumArtworkImageView.layer.masksToBounds = true
    
    setupAlbumArtistLabel(album)
    
    setupGenreLabel(album)
    
    setupCopyrightLabel(album)
    
    setupReleaseDateLabel(album)
    
    setupTitleLabel(album)
    
    
    let albumInfoStackView = UIStackView()
    albumInfoStackView.translatesAutoresizingMaskIntoConstraints = false
    albumInfoStackView.axis = .vertical
    albumInfoStackView.alignment = .fill
    albumInfoStackView.spacing = 8.0
    albumInfoStackView.distribution = .fill
    
    albumInfoStackView.addArrangedSubview(albumTitleLabel)
    albumInfoStackView.addArrangedSubview(albumArtistLabel)
    albumInfoStackView.addArrangedSubview(albumReleaseDateLabel)
    
    
    let metadataStackView = UIStackView()
    metadataStackView.translatesAutoresizingMaskIntoConstraints = false
    metadataStackView.axis = .vertical
    metadataStackView.alignment = .fill
    metadataStackView.spacing = 16.0
    metadataStackView.distribution = .fill
    
    metadataStackView.addArrangedSubview(albumGenreLabel)
    metadataStackView.addArrangedSubview(albumCopyrightLabel)
    albumCopyrightLabel.textAlignment = .right
    
    let mainStackView = UIStackView()
    mainStackView.axis = .vertical
    mainStackView.alignment = .fill
    mainStackView.spacing = 16.0
    mainStackView.distribution = .fill
    
    mainStackView.addArrangedSubview(albumInfoStackView)
    mainStackView.addArrangedSubview(metadataStackView)
    
    self.sv([albumArtworkImageView, mainStackView])
    
    NSLayoutConstraint.activate([
      // Album artwork constraints
      albumArtworkImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      albumArtworkImageView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
      
      // Stack View
      mainStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
      mainStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
      mainStackView.topAnchor.constraint(equalTo: albumArtworkImageView.bottomAnchor, constant: 24.0)
    ])
    
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("No storyboards")
  }
  
  override func layoutSubviews() {
    self.albumArtworkImageView.setNeedsLayout()
    self.albumArtworkImageView.layoutIfNeeded()
    self.albumArtworkImageView.layer.cornerRadius = self.albumArtworkImageView.frame.height / 2.0
    print(self.albumArtworkImageView.frame.height / 2.0)
  }
  
}

// MARK: - View Setup -

extension AlbumDetailView {
  
  fileprivate func setupAlbumArtistLabel(_ album: Album) {
    self.albumArtistLabel.text = album.artist
    self.albumArtistLabel.numberOfLines = 1
    self.albumArtistLabel.font = .preferredFont(forTextStyle: .title2)
  }
  
  fileprivate func setupGenreLabel(_ album: Album) {
    let genres = album.genres.map { $0.name }.joined(separator: ",")
    self.albumGenreLabel.text = "Genres: " + genres
    self.albumGenreLabel.font = .preferredFont(forTextStyle: .subheadline)
    self.albumGenreLabel.numberOfLines = 1
  }
  
  func setReleaseDateLabel(releaseDate: String?) {
    
    if let releaseDate = releaseDate {
      self.albumReleaseDateLabel.text = "Releases on " + releaseDate
    } else {
      self.albumReleaseDateLabel.text = "Releases in the near future"
    }
  }
  
  fileprivate func setupCopyrightLabel(_ album: Album) {
    self.albumCopyrightLabel.text = album.copyright
    self.albumCopyrightLabel.font = .preferredFont(forTextStyle: .caption1)
    self.albumCopyrightLabel.numberOfLines = 0
    self.albumCopyrightLabel.lineBreakMode = .byWordWrapping
  }
  
  fileprivate func setupReleaseDateLabel(_ album: Album) {
    setReleaseDateLabel(releaseDate: album.releaseDate)
    self.albumReleaseDateLabel.numberOfLines = 1
    self.albumReleaseDateLabel.font = .preferredFont(forTextStyle: .title3)
  }
  
  fileprivate func setupTitleLabel(_ album: Album) {
    self.albumTitleLabel.text = album.title
    self.albumTitleLabel.numberOfLines = 0
    self.albumTitleLabel.font = .preferredFont(forTextStyle: .title1)
  }
  
}
