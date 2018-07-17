//
//  EpisodesController.swift
//  Poddler
//
//  Created by Sven Pohle on 7/13/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import UIKit

class EpisodesController: UITableViewController {
    
    var podcast: Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName
        }
    }
    
    fileprivate let cellId = "podcastCellId"
    
    var episodes = [
        Episode(title: "First Episde"),
        Episode(title: "Second Episde"),
        Episode(title: "Third Episde"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    fileprivate func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
}

//MARK: - TABLE VIEW DATA SOURCE
extension EpisodesController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = "\(episodes[indexPath.row].title)"
        
        return cell
    }
}
