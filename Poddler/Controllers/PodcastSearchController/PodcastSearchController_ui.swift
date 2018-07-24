//
//  PodcastSearchController_ui.swift
//  Poddler
//
//  Created by Sven Pohle on 7/24/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import UIKit

class OverlayView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = ColorTheme.searchController.overlayColor
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class OverlayLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        text = "No Search Results Yet..."
        textAlignment = .center
        textColor = UIColor(r: 150, g: 150, b: 150)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PodcastsSearchController {
    func setupOverlayView() {
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
    
    func setupSearchBar() {
        self.definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for Podcasts..."
        searchController.delegate = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    
    func setupTableView() {
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.separatorColor = .clear
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: podcastsSearchTableCellId)
    }
}

