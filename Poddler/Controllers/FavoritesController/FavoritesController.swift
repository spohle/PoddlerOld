//
//  FavoritesController.swift
//  Poddler
//
//  Created by Pohle, Sven on 8/1/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import UIKit
import CoreData

class FavoritesController: UITableViewController
{
    let cellId = "favoriteCellId"
    
    lazy var uiAddButton:UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "favorites")?.imageScaled(to: CGSize(width: view.frame.width, height: view.frame.width))
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(searchForPodcastsCb), for: .touchUpInside)
        return button
    }()
    
    var favorites = [Podcast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFavoritePodcasts()
    }
    
    func getFavoritePodcasts() {
        CoreDataService.shared.getSubscribedPodcasts { (podcasts) in
            self.favorites = podcasts
            self.setupUserInterface()
            self.tableView.reloadData()
        }
    }
    
    @objc fileprivate func searchForPodcastsCb() {
        let searchController = PodcastsSearchController()
        self.navigationController?.pushViewController(searchController, animated: true)
    }
}


