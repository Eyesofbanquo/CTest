//
//  AlbumDetailView.swift
//  CodeTest
//
//  Created by Markim Shaw on 2/20/20.
//  Copyright © 2020 Markim Shaw. All rights reserved.
//

import Foundation
import UIKit

class AlbumDetailView: UIView {
  
  // MARK: - Properties -
    
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
    
    setupAlbumArtworkImageView(artwork)
    
    setupBackgroundImageView(artwork)
    
    setupAlbumArtistLabel(album)
    
    setupGenreLabel(album)
    
    setupCopyrightLabel(album)
    
    setupReleaseDateLabel(album)
    
    setupTitleLabel(album)
    
    setupButton()
    
    let labelContainerView = UIView()
    labelContainerView.layer.cornerRadius = 8.0
    labelContainerView.translatesAutoresizingMaskIntoConstraints = false
    labelContainerView.backgroundColor = .tertiarySystemGroupedBackground
    
    let albumInfoStackView = createStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 0.0)
    albumInfoStackView.addArrangedSubview(albumTitleLabel)
    albumInfoStackView.addArrangedSubview(albumArtistLabel)
    albumInfoStackView.addArrangedSubview(albumReleaseDateLabel)
    albumInfoStackView.addArrangedSubview(albumGenreLabel)
    
    let mainStackView = createStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 32.0)
    mainStackView.addArrangedSubview(albumInfoStackView)
    mainStackView.addArrangedSubview(albumCopyrightLabel)
    albumCopyrightLabel.textAlignment = .right
    
    labelContainerView.sv([mainStackView])
    
    self.sv([albumArtworkImageView, labelContainerView, openURLButton])
    self.insertSubview(backgroundImageView, belowSubview: albumArtworkImageView)
    self.insertSubview(blurEffectView, aboveSubview: backgroundImageView)
    
    NSLayoutConstraint.activate([
      // Album artwork constraints
      albumArtworkImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      albumArtworkImageView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
      albumArtworkImageView.widthAnchor.constraint(equalToConstant: 200.0),
      albumArtworkImageView.heightAnchor.constraint(equalToConstant: 200.0),
      
      // Label Container View
      labelContainerView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
      labelContainerView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
      labelContainerView.topAnchor.constraint(equalTo: albumArtworkImageView.bottomAnchor, constant: 24.0),
      labelContainerView.bottomAnchor.constraint(equalTo: openURLButton.topAnchor, constant: -24.0),
      
      // Stack View
      mainStackView.leadingAnchor.constraint(equalTo: labelContainerView.layoutMarginsGuide.leadingAnchor, constant: 8.0),
      mainStackView.trailingAnchor.constraint(equalTo: labelContainerView.layoutMarginsGuide.trailingAnchor, constant: -8.0),
      mainStackView.topAnchor.constraint(equalTo: labelContainerView.layoutMarginsGuide.topAnchor, constant: 8.0),
      
      // Background Image View
      backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
      backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
      blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
      blurEffectView.topAnchor.constraint(equalTo: topAnchor),
      blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
      
      openURLButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20.0),
      openURLButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0),
      openURLButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20.0)
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
    
    self.albumArtworkImageView.layer.borderWidth = 1.0
    self.albumArtworkImageView.layer.borderColor = UIColor.label.cgColor
    
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
  
  fileprivate func setupAlbumArtworkImageView(_ artwork: UIImage?) {
    self.albumArtworkImageView.image = artwork
    self.albumArtworkImageView.layoutIfNeeded()
    self.albumArtworkImageView.translatesAutoresizingMaskIntoConstraints = false
    self.albumArtworkImageView.contentMode = .scaleAspectFit
    self.albumArtworkImageView.layer.masksToBounds = true
    
    self.albumArtworkImageView.layer.borderWidth = 1.0
    self.albumArtworkImageView.layer.borderColor = UIColor.label.cgColor
  }
  
  fileprivate func createStackView(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat) -> UIStackView {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = axis
    stackView.alignment = alignment
    stackView.spacing = spacing
    stackView.distribution = distribution
    
    return stackView
  }
  
  fileprivate func setupBackgroundImageView(_ artwork: UIImage?) {
    let motionEffectGroup = UIMotionEffectGroup()
    let min = CGFloat(-10)
    let max = CGFloat(10)
    let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
    let yMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.y", type: .tiltAlongVerticalAxis)
    
    xMotion.minimumRelativeValue = min
    xMotion.maximumRelativeValue = max
    yMotion.minimumRelativeValue = min
    yMotion.maximumRelativeValue = max
    
    motionEffectGroup.motionEffects = [xMotion, yMotion]
    
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundImageView.image = artwork
    self.backgroundImageView.contentMode = .scaleAspectFill
    self.backgroundImageView.layer.masksToBounds = true
    backgroundImageView.addMotionEffect(motionEffectGroup)
  }
  
  fileprivate func setupAlbumArtistLabel(_ album: Album) {
    self.albumArtistLabel.text = album.artist
    self.albumArtistLabel.numberOfLines = 1
    self.albumArtistLabel.font = .preferredFont(forTextStyle: .title2)
  }
  
  fileprivate func setupGenreLabel(_ album: Album) {
    let genres = album.genres.map { $0.name }.joined(separator: ",")
    self.albumGenreLabel.text = "Genres: " + genres
    self.albumGenreLabel.font = .preferredFont(for: .subheadline, weight: .light)
    self.albumGenreLabel.numberOfLines = 1
  }
  
  fileprivate func setupCopyrightLabel(_ album: Album) {
    self.albumCopyrightLabel.text = album.copyright
    self.albumCopyrightLabel.textColor = .label
    self.albumCopyrightLabel.font = .preferredFont(for: .caption2, weight: .light)
    self.albumCopyrightLabel.numberOfLines = 0
    self.albumCopyrightLabel.lineBreakMode = .byWordWrapping
  }
  
  fileprivate func setupReleaseDateLabel(_ album: Album) {
    if let readableDate = album.readableDate {
       self.albumReleaseDateLabel.text = "Releases on " + readableDate
    } else {
      self.albumReleaseDateLabel.text = "Releases in the near future"
    }
    self.albumReleaseDateLabel.numberOfLines = 1
    self.albumReleaseDateLabel.font = .preferredFont(for: .headline, weight: .light)
  }
  
  fileprivate func setupTitleLabel(_ album: Album) {
    self.albumTitleLabel.text = album.title
    self.albumTitleLabel.numberOfLines = 0
    self.albumTitleLabel.font = .preferredFont(for: .title1, weight: .bold)
  }
  
  fileprivate func setupButton() {
    openURLButton.layer.cornerRadius = 8.0
    openURLButton.contentEdgeInsets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
    openURLButton.backgroundColor = .systemPink
    openURLButton.setTitle("Open in  Apple Music", for: .normal)
    openURLButton.setTitleColor(.white, for: .normal)
    openURLButton.addTarget(self, action: #selector(self.launchItunes), for: .touchUpInside)
  }
  
  @objc private func launchItunes() {
    if let url = URL(string: album.appleMusicURL) {
      if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
    }
  }
}

extension AlbumDetailView: AlbumDetailViewControllerDisplayable {
  func updateBackgroundImage(image: UIImage?) {
    
    UIView.transition(with: self.backgroundImageView, duration: 0.65, options: .transitionCrossDissolve, animations: {
      self.backgroundImageView.image = image
    }, completion: nil)
    
    
    UIView.transition(with: self.albumArtworkImageView, duration: 1.25, options: .transitionCrossDissolve, animations: {
    self.albumArtworkImageView.image = image
    }, completion: nil)
  }
  
  
}
