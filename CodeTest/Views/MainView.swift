//
//  MainView.swift
//  CodeTest
//
//  Created by Markim Shaw on 2/19/20.
//  Copyright © 2020 Markim Shaw. All rights reserved.
//

import Foundation
import UIKit

protocol MainViewDelegate: AnyObject {
  
  var storage: Storage { get }
  
  func launchDetailViewController(forAlbum album: Album)
  
  func retrieveImage(forAlbum album: Album?, at index: IndexPath, _ completion: @escaping (IndexPath, UIImage?) -> Void)
  
}

class MainView: UIView {
  
  // MARK: - Properties -
  
  weak var delegate: MainViewDelegate?
  
  // MARK: - Views -
  
  var tableView: UITableView
  
  init() {
    tableView = UITableView(frame: .zero, style: .insetGrouped)
    tableView.backgroundColor = .systemGroupedBackground
    
    super.init(frame: .zero)
    
    tableView.register(AlbumCell.self, forCellReuseIdentifier: AlbumCell.reuseIdentifier)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.tableFooterView = UIView()
    
    backgroundColor = .systemGroupedBackground
    
    sv([tableView])
    
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
      tableView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
    ])
    
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("Don't use storyboards")
  }
}

extension MainView: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let row = indexPath.row
    
    if let album = delegate?.storage.get(index: row) {
      delegate?.launchDetailViewController(forAlbum: album)
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension MainView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return delegate?.storage.count ?? 0
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: AlbumCell.reuseIdentifier, for: indexPath)
    
    guard let albumCell = cell as? AlbumCell else { return cell }
    
    let row = indexPath.row
    let album = delegate?.storage.get(index: row)
    albumCell.configure(forAlbum: album)
    
    if let image = delegate?.storage.retrieveImage(forId: album?.id ?? ""){
      albumCell.setImage(image: image)
    } else {
      delegate?.retrieveImage(forAlbum: album, at: indexPath, { id, image in
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows, visibleIndexPaths.contains(id) {
          let cell = tableView.cellForRow(at: id) as? AlbumCell
          UIView.performWithoutAnimation {
            tableView.beginUpdates()
            cell?.setImage(image: image)
            tableView.endUpdates()
          }
        }
      })
    }
    return albumCell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Upcoming Albums"
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    if let header = view as? UITableViewHeaderFooterView {
      header.textLabel?.textColor = .label
    }
  }
  
}

extension MainView: MainViewControllerDisplayable {
  func updateView() {
    UIView.performWithoutAnimation {
      self.tableView.reloadData()
    }
  }
}
