//
//  PodcastController_table.swift
//  Poddler
//
//  Created by Sven Pohle on 7/24/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import UIKit

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

