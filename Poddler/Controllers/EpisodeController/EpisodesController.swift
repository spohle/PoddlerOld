//
//  EpisodesController.swift
//  Poddler
//
//  Created by Sven Pohle on 7/13/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import UIKit

class EpisodesController: UITableViewController {
    
    var episodes = [Episode]()
    
    var podcast: Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName
            
            guard let feedUrl = podcast?.feedUrl else { return }
            APIService.shared.fetchEpisodes(baseUrl: feedUrl) { (episodes) in
                self.episodes = episodes
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    let cellId = "podcastCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let favImage = UIImage(named: "favempty")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: favImage, style: .plain,
                                                            target: self, action: #selector(favPodcast))
        setupTableView()
    }
    
    @objc func favPodcast() {
        
    }
}
