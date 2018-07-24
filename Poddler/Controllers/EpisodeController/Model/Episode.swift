//
//  Episode.swift
//  Poddler
//
//  Created by Sven Pohle on 7/17/18.
//  Copyright © 2018 Pohle, Sven. All rights reserved.
//

import Foundation
import FeedKit

struct Episode {
    var title: String
    var pubDate: Date
    var summary: String
    var streamUrl: String
    var imageUrl: String
    var author: String
    
    init(feedItem: RSSFeedItem) {
        self.author    = feedItem.iTunes?.iTunesAuthor ?? ""
        self.title     = feedItem.title ?? ""
        self.pubDate   = feedItem.pubDate ?? Date()
        self.summary   = feedItem.iTunes?.iTunesSummary ?? ""
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
        self.imageUrl  = feedItem.iTunes?.iTunesImage?.attributes?.href ?? feedItem.iTunes?.iTunesImage?.attributes?.href ?? ""
    }
}


