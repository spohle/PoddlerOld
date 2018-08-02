//
//  PodcastSearchController.swift
//  Poddler
//
//  Created by Sven Pohle on 7/12/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class PodcastsSearchController: UITableViewController {
    
    var podcasts = [Podcast]()
    
    let podcastsSearchTableCellId = "podcastsSearchTableCellId"
    let searchController = UISearchController(searchResultsController: nil)
    let animationDuration = 0.25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadModel()
        setupTableView()
        setupSearchBar()
        setupOverlayView()
    }
    
    let uiOverlayView = OverlayView(frame: CGRect.zero)
    let uiOverlayLabel = OverlayLabel(frame: CGRect.zero)
    
    func loadModel() {
        
    }
}
