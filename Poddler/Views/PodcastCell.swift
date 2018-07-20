//
//  PodcastCell.swift
//  Poddler
//
//  Created by Sven Pohle on 7/12/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import UIKit
import SDWebImage

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
            podcastImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "appicon"))
            
            podcastImageView.clipsToBounds = true
            podcastImageView.layer.cornerRadius = 10
        }
    }
}
