//
//  PodcastCell.swift
//  Poddler
//
//  Created by Sven Pohle on 7/12/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import UIKit


class PodcastCell: UITableViewCell {
    
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var podcastTrackNameLabel: UILabel!
    @IBOutlet weak var podcastEpisodeCountLabel: UILabel!
    @IBOutlet weak var podcastArtistNameLabel: UILabel!
    
    var podcast: Podcast! {
        didSet {
            podcastTrackNameLabel.text = podcast.trackName
            podcastArtistNameLabel.text = podcast.artistName
            podcastImageView.image = UIImage(named: "appicon")
            podcastEpisodeCountLabel.text = "\(podcast.trackCount ?? 0) Episodes"
            
            guard let url = URL(string: podcast.artworkUrl600 ?? "") else { return }
            URLSession.shared.dataTask(with: url) { (data, _, _) in
                
                guard let imageData = data else { return }
                
                DispatchQueue.main.async {
                    self.podcastImageView.image = UIImage(data: imageData)
                }
                
            }.resume()
        }
    }
}