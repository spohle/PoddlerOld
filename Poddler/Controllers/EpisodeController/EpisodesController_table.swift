//
//  EpisodesController_table.swift
//  Poddler
//
//  Created by Sven Pohle on 7/24/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import UIKit

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
            cell.backgroundColor = UIColor(r: 55, g: 55, b: 55)
        } else {
            cell.backgroundColor = UIColor(r: 40, g: 40, b: 40)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        
        let window = UIApplication.shared.keyWindow
        guard var frame = window?.frame else { return }
        frame.origin.y += frame.size.height
        let playerView = EpisodePlayerView(frame: frame)
        playerView.episode = episode
        playerView.podcastImageUrl = self.podcast?.artworkUrl600 ?? ""
        playerView.setupUserInterface()
        window?.addSubview(playerView)
        playerView.prepareToPlay()
        //        playerView.play()
        
        UIView.animate(withDuration: 0.3) {
            playerView.frame.origin.y = 0.0
        }
    }
}

