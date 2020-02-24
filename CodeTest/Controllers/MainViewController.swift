//
//  MainViewController.swift
//  CodeTest
//
//  Created by Markim Shaw on 2/19/20.
//  Copyright © 2020 Markim Shaw. All rights reserved.
//

import Foundation
import UIKit

protocol MainViewControllerDisplayable {
  
  func updateView()
}

class MainViewController: UIViewController {
  
  // MARK: - Network -
  
  lazy var rssFeed: String = "https://rss.itunes.apple.com/api/v1/us/apple-music/coming-soon/all/100/explicit.json"
  
  // MARK: - Properties -
  
  var storage: Storage
  
  var network: Network<AppleMusic>
  
  var operationManager: OperationManager
  
  // MARK: - Views -
  
  var displyableView: MainViewControllerDisplayable? {
    return view as? MainViewControllerDisplayable
  }
  
  // MARK: - Initializers -
  
  init(storage: Storage = Storage(), network: Network<AppleMusic> = Network<AppleMusic>(), operationManager: OperationManager = OperationManager()) {
    self.storage = storage
    self.network = network
    self.operationManager = operationManager
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("Don't use storyboards for this test")
  }
  
  // MARK: - Lifecycle -
  
  override func loadView() {
    let mainView = MainView()
    mainView.delegate = self
    
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Nike☑️ Code Test"
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    network.get(url: URL(string: rssFeed)) { [weak self] results in
        switch results {
        case .success(let response):
          let results = response.results
          self?.storage.add(albums: results)
          self?.displyableView?.updateView()
        case .failure(let error):
          print(error.localizedDescription)
        }
    }
  }
}

extension MainViewController: MainViewDelegate {
  func launchDetailViewController(forAlbum album: Album) {
    let storedCache = storage.retrieveImage(forId: album.id)
    
    let detailViewController = AlbumDetailViewController(album: album, artwork: storedCache)
    
    navigationController?.pushViewController(detailViewController, animated: true)
  }
  
  func retrieveImage(forAlbum album: Album?, at index: IndexPath, _ completion: @escaping (IndexPath, UIImage?) -> Void){
    
    guard let album = album else {
      completion(index, nil)
      return
    }
    
    // In this case, the operation is downloading but has not completed
    if operationManager.get(id: album.id) != nil && operationManager.get(id: album.id)?.isExecuting == true {
     completion(index, nil)
      return
    }
    
    if let cachedImage = storage.retrieveImage(forId: album.id) {
      completion(index, cachedImage)
      return
    }
    
    if let downloadOperation = (DownloadOperation(id: album.id, url: URL(string: album.artwork), session: network.session) { [weak self] id, image in
      self?.storage.saveImage(forId: album.id, value: image)
      
      if let downloadedId = id {
        self?.operationManager.remove(id: downloadedId)
      }
      
      completion(index, image)
    }) {
      operationManager.add(id: album.id, op: downloadOperation)
    }
  }
}

extension MainViewController {
  
  static func navigationController(storage: Storage = Storage(), network: Network<AppleMusic> = Network<AppleMusic>(), operationManager: OperationManager = OperationManager()) -> UINavigationController {
    
    let mainViewController = MainViewController(storage: storage, network: network, operationManager: operationManager)
    let navigationController = UINavigationController(rootViewController: mainViewController)
    
    navigationController.navigationBar.prefersLargeTitles = true
    navigationController.navigationBar.tintColor = .label
    navigationController.navigationItem.largeTitleDisplayMode = .automatic
    
    
    let navigationAppearance = UINavigationBarAppearance()
    navigationAppearance.configureWithTransparentBackground()
    navigationAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
    navigationAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
    
    navigationController.navigationBar.scrollEdgeAppearance = navigationAppearance
    navigationController.navigationBar.compactAppearance = navigationAppearance
    navigationController.navigationBar.standardAppearance = navigationAppearance
    
    return navigationController

  }
}
