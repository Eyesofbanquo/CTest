//
//  AlbumCell.swift
//  CodeTest
//
//  Created by Markim Shaw on 2/20/20.
//  Copyright © 2020 Markim Shaw. All rights reserved.
//

import Foundation
import UIKit

class AlbumCell: UITableViewCell {
  
  static var reuseIdentifier: String = "AlbumCell"
  
  // MARK: - Views -
    
  var artworkImageView: UIImageView
  
  var albumTitleLabel: UILabel
  
  var albumArtistLabel: UILabel
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    let mainStackView = UIStackView()
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.axis = .horizontal
    mainStackView.spacing = 8.0
    mainStackView.distribution = .fill
    mainStackView.alignment = .center
    
    let labelStackView = UIStackView()
    labelStackView.translatesAutoresizingMaskIntoConstraints = false
    labelStackView.axis = .vertical
    labelStackView.spacing = 0.0
    labelStackView.distribution = .fill
    labelStackView.alignment = .fill
    
    artworkImageView = UIImageView()
    artworkImageView.contentMode = .scaleAspectFit
    artworkImageView.layer.masksToBounds = true
    artworkImageView.layer.cornerRadius = 4.0
    NSLayoutConstraint.activate([
      artworkImageView.widthAnchor.constraint(equalToConstant: 80.0),
      artworkImageView.heightAnchor.constraint(equalToConstant: 80.0)
    ])
    
    albumTitleLabel = UILabel()
    albumTitleLabel.translatesAutoresizingMaskIntoConstraints = false
    albumTitleLabel.font = .preferredFont(forTextStyle: .headline)
    albumTitleLabel.textColor = .label
    albumTitleLabel.numberOfLines = 0
    albumTitleLabel.lineBreakMode = .byWordWrapping
    
    albumArtistLabel = UILabel()
    albumArtistLabel.translatesAutoresizingMaskIntoConstraints = false
    albumArtistLabel.textColor = .label
    albumArtistLabel.font = .preferredFont(forTextStyle: .subheadline)
    albumArtistLabel.numberOfLines = 0
    albumArtistLabel.lineBreakMode = .byWordWrapping
    
    
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    labelStackView.addArrangedSubview(albumTitleLabel)
    labelStackView.addArrangedSubview(albumArtistLabel)
    
    mainStackView.addArrangedSubview(artworkImageView)
    mainStackView.addArrangedSubview(labelStackView)
    
    sv([mainStackView])
    
    NSLayoutConstraint.activate([
      mainStackView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
      mainStackView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
      mainStackView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
      mainStackView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    albumTitleLabel.text = nil
    albumArtistLabel.text = nil
    artworkImageView.image = nil
  }
  
  func configure(forAlbum album: Album?) {
    guard let album = album else { return }
    
    albumTitleLabel.text = album.title
    albumArtistLabel.text = album.artist
  }
  
  func setImage(image: UIImage?) {
    artworkImageView.image = image
  }
}
