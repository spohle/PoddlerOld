//
//  EpisodeCell.swift
//  Poddler
//
//  Created by Sven Pohle on 7/17/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import UIKit
import SDWebImage

class EpisodeCell: UITableViewCell {
   
    @IBOutlet weak var uiTitle: UILabel!
    @IBOutlet weak var uiDate: UILabel!
    @IBOutlet weak var uiSummary: UILabel!
    
    var episode: Episode! {
        didSet {
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM dd, yyyy"
            
            uiTitle.numberOfLines = 0
            uiTitle.text = episode.title
            uiDate.text = dateFormatterPrint.string(from: episode.pubDate)
            uiSummary.text = episode.summary
            
            uiTitle.textColor = UIColor.white.withAlphaComponent(0.9)
            uiSummary.textColor = UIColor.white.withAlphaComponent(0.75)
            uiDate.textColor = UIColor.white.withAlphaComponent(0.5)
            
            self.layoutSubviews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        uiTitle.sizeToFit()
    }
}
