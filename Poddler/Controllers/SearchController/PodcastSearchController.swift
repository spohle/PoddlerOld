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
    let animationDuration = 0.25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
        setupOverlayView()
    }
    
    let uiOverlayView: UIView = {
       let view = UIView()
        view.backgroundColor = ColorTheme.searchController.overlayColor
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let uiOverlayLabel: UILabel = {
       let label = UILabel()
        
        label.text = "No Search Results Yet..."
        label.textAlignment = .center
        label.textColor = UIColor(r: 150, g: 150, b: 150)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    fileprivate func setupOverlayView() {
        guard let navView = self.navigationController?.view else { return }
        
        var searchBarHeight:CGFloat = (navigationController?.navigationBar.frame.height)! * 2.0
        searchBarHeight += searchController.searchBar.frame.height
        
        navView.addSubview(uiOverlayView)
        uiOverlayView.centerXAnchor.constraint(equalTo: navView.centerXAnchor).isActive = true
        uiOverlayView.widthAnchor.constraint(equalTo: navView.widthAnchor).isActive = true
        uiOverlayView.topAnchor.constraint(equalTo: navView.topAnchor, constant: searchBarHeight).isActive = true
        uiOverlayView.bottomAnchor.constraint(equalTo: navView.bottomAnchor).isActive = true
        
        uiOverlayView.addSubview(uiOverlayLabel)
        uiOverlayLabel.centerXAnchor.constraint(equalTo: uiOverlayView.centerXAnchor).isActive = true
        uiOverlayLabel.topAnchor.constraint(equalTo: uiOverlayView.topAnchor, constant: 100).isActive = true
        uiOverlayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        uiOverlayLabel.widthAnchor.constraint(equalTo: uiOverlayView.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    //MARK: - SearchBar
    fileprivate func setupSearchBar() {
        self.definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for Podcasts..."
        searchController.delegate = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    
    fileprivate func setupTableView() {
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.separatorColor = .clear
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
        
        if indexPath.row%2 == 0 {
            cell.backgroundColor = UIColor(r: 55, g: 55, b: 55)
        } else {
            cell.backgroundColor = UIColor(r: 40, g: 40, b: 40)
        }
        
        let podcast = self.podcasts[indexPath.row]
        cell.podcast = podcast
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let episodesController = EpisodesController()
        episodesController.podcast = podcasts[indexPath.row]
        navigationController?.pushViewController(episodesController, animated: true)
    }
}

//MARK: - EXTENSIONS
extension PodcastsSearchController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.uiOverlayView.backgroundColor = self.uiOverlayView.backgroundColor?.withAlphaComponent(0.0)
            self.uiOverlayView.frame.origin.y = 400
        }) { (finished) in
            self.uiOverlayView.isHidden = true
        }
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        if self.podcasts.count == 0 {
            
            self.uiOverlayView.isHidden = false
            UIView.animate(withDuration: animationDuration) {
                self.uiOverlayView.backgroundColor = self.uiOverlayView.backgroundColor?.withAlphaComponent(1.0)
                self.uiOverlayView.frame.origin.y = 0
            }
        }
    }
}

extension PodcastsSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (timer) in
            APIService.shared.fetchPodcasts(searchText: searchText) { (podcasts) in
                self.podcasts = podcasts
                self.tableView.reloadData()
            }
        }
    }
}


