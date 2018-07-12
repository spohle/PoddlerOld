//
//  PodcastSearchController.swift
//  Poddler
//
//  Created by Sven Pohle on 7/12/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import UIKit
import Alamofire

class PodcastsSearchController: UITableViewController {
    
    var podcasts = [Podcast]()
    
    let podcastsSearchTableCellId = "podcastsSearchTableCellId"
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
    }
    
    //MARK: - SearchBar
    fileprivate func setupSearchBar() {
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for Podcasts..."
        searchController.delegate = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    
    fileprivate func setupTableView() {
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: podcastsSearchTableCellId)
    }
}

//MARK: - TableView DataSource
extension PodcastsSearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: podcastsSearchTableCellId, for: indexPath) as! PodcastCell
        
        let podcast = podcasts[indexPath.row]
        
        cell.podcast = podcast
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
}

//MARK: - EXTENSIONS
extension PodcastsSearchController: UISearchControllerDelegate {
    func didPresentSearchController(_ searchController: UISearchController) {
        // this is where we should request the network data
    }
}

extension PodcastsSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        APIService.shared.fetchPodcasts(searchText: searchText) { (podcasts) in
            self.podcasts = podcasts
            self.tableView.reloadData()
        }
    }
}


