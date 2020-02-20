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
  
  lazy var blurEffectView: UIVisualEffectView = createVisualEffectView()
  
  var backgroundImageView: UIImageView
  
  var albumArtworkImageView: UIImageView
  
  var albumArtistLabel: UILabel
  
  var albumTitleLabel: UILabel
  
  var albumGenreLabel: UILabel
  
  var albumCopyrightLabel: UILabel
  
  var albumReleaseDateLabel: UILabel
  
  var openURLButton: UIButton
  
  init(album: Album, artwork: UIImage?) {
    self.album = album
    backgroundImageView = UIImageView()
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
    
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundImageView.contentMode = .scaleAspectFill
    self.backgroundImageView.layer.masksToBounds = true
    
    self.backgroundImageView.alpha = 0
    self.blurEffectView.alpha = 0
    
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
    self.insertSubview(backgroundImageView, belowSubview: albumArtworkImageView)
    self.insertSubview(blurEffectView, aboveSubview: backgroundImageView)
    
    NSLayoutConstraint.activate([
      // Album artwork constraints
      albumArtworkImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      albumArtworkImageView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
      
      // Stack View
      mainStackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
      mainStackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
      mainStackView.topAnchor.constraint(equalTo: albumArtworkImageView.bottomAnchor, constant: 24.0),
      
      // Background Image View
      backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
      backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
      blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
      blurEffectView.topAnchor.constraint(equalTo: topAnchor),
      blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
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
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    
    UIView.animate(withDuration: 0.65) {
      switch self.traitCollection.userInterfaceStyle {
      case .dark:
        self.blurEffectView.effect = UIBlurEffect(style: .dark)
      case .light:
        self.blurEffectView.effect = UIBlurEffect(style: .light)
      default: break
      }
    }
  }
  
  func createVisualEffectView() -> UIVisualEffectView {
    let blur: UIBlurEffect
    
    if self.traitCollection.userInterfaceStyle == .dark {
      blur = UIBlurEffect(style: .dark)
    } else {
      blur = UIBlurEffect(style: .light)
    }
    
    let imageEffectView = UIVisualEffectView(effect: blur)
    imageEffectView.translatesAutoresizingMaskIntoConstraints = false
    
    return imageEffectView
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

extension AlbumDetailView: AlbumDetailViewControllerDisplayable {
  func updateBackgroundImage(image: UIImage?) {
    
    UIView.animate(withDuration: 0.65) {
      self.backgroundImageView.alpha = 1
      self.blurEffectView.alpha = 1
      self.backgroundImageView.image = image
    }
  }
  
  
}
