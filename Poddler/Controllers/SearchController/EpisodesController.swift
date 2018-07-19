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
    
    fileprivate let cellId = "podcastCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    fileprivate func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(r: 40, g: 40, b: 40)
    }
}

//MARK: - TABLE VIEW DATA SOURCE
extension EpisodesController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        
        let episode = self.episodes[indexPath.row]
        cell.episode = episode
        
        if indexPath.row%2 == 0 {
            cell.backgroundColor = UIColor(r: 225, g: 225, b: 225)
        } else {
            cell.backgroundColor = UIColor(r: 240, g: 240, b: 240)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//MARK: - TABLE VIEW DELEGATE
extension EpisodesController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        
        let window = UIApplication.shared.keyWindow
        guard var frame = window?.frame else { return }
        frame.origin.y += frame.size.height
        let playerView = EpisodePlayerView(frame: frame)
        playerView.episode = episode
        playerView.setupUserInterface()
        window?.addSubview(playerView)
        
        UIView.animate(withDuration: 0.3) {
            playerView.frame.origin.y = 0.0
        }
    }
}
