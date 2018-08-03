//
//  EpisodesController.swift
//  Poddler
//
//  Created by Sven Pohle on 7/13/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import UIKit
import CoreData

class EpisodesController: UITableViewController {
    
    var episodes = [Episode]()
    var subscribed:Bool = false {
        didSet {
            var favImage = UIImage(named: "favempty")
            if self.subscribed == true {
                favImage = UIImage(named: "fav")
            }
            navigationItem.rightBarButtonItem?.image = favImage
        }
    }
    
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
                                                            target: self, action: #selector(changeSubscriptionStatus))
        
        self.subscribed = self.podcast?.getSubscribedStatus() ?? false
        setupTableView()
    }
    
    func getSubscribedStatus() {
        let service = CoreDataService.shared
        self.subscribed = service.getSubscribedStatus(podcast: self.podcast!)
    }
    
    @objc func changeSubscriptionStatus() {
        self.subscribed = !self.subscribed
        let service = CoreDataService.shared
        service.updateSubscribedStatus(podcast: self.podcast!, subscribed: self.subscribed)
    }
}
